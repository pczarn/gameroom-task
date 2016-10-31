import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'
import _ from 'lodash'

import api from 'src/api'
import auth from 'src/auth'
import router from 'src/router'

import { rawTeam, rawMatch, rawTournament, rawTournamentParams, rawFriendlyMatch } from 'src/store/mapping'
import session from 'src/store/session'
import teams from 'src/store/teams'
import matches from 'src/store/matches'
import games from 'src/store/games'
import tournaments from 'src/store/tournaments'
import users from 'src/store/users'
import alert from 'src/store/alert'

Vue.use(Vuex)

export const store = new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production',
  modules: {
    session,
    games,
    teams,
    matches,
    tournaments,
    users,
    alert,
  },
  mutations: {
    SET_EVERYTHING (state, lists) {
      state.games.games = lists.games
      state.teams.teams = lists.teams
      state.matches.matches = lists.matches
      state.tournaments.tournaments = lists.tournaments
      state.users.users = lists.users
    },
  },
  actions: {
    async LOG_IN ({ commit, dispatch }, creds) {
      const userWithToken = await api.getUserWithToken(creds)
      commit('SET_CURRENT_USER_AND_TOKEN', userWithToken)
      auth.logIn(userWithToken)
      router.push('/')
      dispatch('GET_EVERYTHING')
    },
    LOG_OUT ({ commit }) {
      auth.logOut()
      commit('RESET_CURRENT_USER_AND_TOKEN')
    },

    SET_ERROR ({ commit }, alert) {
      commit('SET_ERROR', alert)
    },

    async GET_EVERYTHING ({ commit }) {
      const lists = await axios.all([
        api.getGames(),
        api.getTeams(),
        api.getMatches(),
        api.getTournaments(),
        api.getUsers(),
      ])
      commit('SET_EVERYTHING', {
        games: lists[0],
        teams: lists[1],
        matches: lists[2],
        tournaments: lists[3],
        users: lists[4],
      })
    },

    async GET_USERS ({ commit }) {
      const users = await api.getUsers()
      commit('SET_USER_LIST', users)
    },
    async CREATE_USER ({ dispatch }, userParams) {
      await api.createUser(userParams)
      dispatch('LOG_IN', { email: userParams.email, password: userParams.password })
    },
    async UPDATE_USER ({ commit, getters }, userParams) {
      const user = await api.updateUser(userParams)
      commit('SET_USER', user)
      if(getters.currentUser && user.id === getters.currentUser.id) {
        commit('SET_CURRENT_USER', user)
      }
    },

    async GET_GAMES ({ commit }) {
      const games = await api.getGames()
      commit('SET_GAME_LIST', games)
    },
    async CREATE_GAME ({ commit }, game) {
      game = await api.createGame(game)
      commit('ADD_GAME', game)
    },
    async UPDATE_GAME ({ commit }, game) {
      game = await api.updateGame(game)
      commit('SET_GAME', game)
    },
    async DESTROY_GAME ({ commit }, { id }) {
      await api.destroyGame(id)
      commit('REMOVE_GAME', { id: id })
    },

    async GET_TEAMS ({ commit }) {
      const teams = await api.getTeams()
      commit('SET_TEAM_LIST', teams)
    },
    async CREATE_TEAM ({ commit }, team) {
      team = await api.createTeam(rawTeam(team))
      commit('ADD_TEAM', team)
      return team
    },
    async UPDATE_TEAM ({ commit }, team) {
      team = await api.updateTeam(rawTeam(team))
      commit('SET_TEAM', team)
    },

    async GET_MATCHES ({ commit }) {
      const teams = await api.getMatches()
      commit('SET_MATCH_LIST', teams)
    },
    async CREATE_MATCH ({ commit, getters, dispatch }, match) {
      const teamOneMemberIds = match.teamOne.members.map(m => m.id).sort()
      const teamTwoMemberIds = match.teamTwo.members.map(m => m.id).sort()
      const currentTeamOne = getters.teamMap.get(match.teamOne.id)
      const currentTeamTwo = getters.teamMap.get(match.teamTwo.id)
      // console.log(teamOneMemberIds, currentTeamOne)
      if(!currentTeamOne || !_.isEqual(teamOneMemberIds, currentTeamOne.members.map(m => m.id).sort())) {
        const reusedTeam = getters.teamByMemberIdsMap.get(teamOneMemberIds.toString())
        if(reusedTeam) {
          match.teamOne.id = reusedTeam.id
        } else {
          const team = await dispatch('CREATE_TEAM', {
            name: match.teamOne.name,
            members: match.teamOne.members,
          })
          match.teamOne.id = team.id
        }
      }
      if(!currentTeamTwo || !_.isEqual(teamTwoMemberIds, currentTeamTwo.members.map(m => m.id).sort())) {
        const reusedTeam = getters.teamByMemberIdsMap.get(teamTwoMemberIds.toString())
        if(reusedTeam) {
          match.teamTwo.id = reusedTeam.id
        } else {
          const team = await dispatch('CREATE_TEAM', {
            name: match.teamTwo.name,
            members: match.teamTwo.members,
          })
          match.teamTwo.id = team.id
        }
      }
      match = await api.createMatch(rawFriendlyMatch(match))
      commit('ADD_MATCH', match)
    },
    async UPDATE_MATCH ({ commit, dispatch, getters }, match) {
      const teamOneMemberIds = match.teamOne.members.map(m => m.id).sort()
      const teamTwoMemberIds = match.teamTwo.members.map(m => m.id).sort()
      const currentMatch = getters.matchMap.get(match.id)
      if(!_.isEqual(teamOneMemberIds, currentMatch.teamOne.members.map(m => m.id).sort())) {
        dispatch('UPDATE_MATCH_LINEUP', [match, match.teamOne])
      }
      if(!_.isEqual(teamTwoMemberIds, currentMatch.teamTwo.members.map(m => m.id).sort())) {
        dispatch('UPDATE_MATCH_LINEUP', [match, match.teamTwo])
      }
      const rawMatch = rawFriendlyMatch(match)
      rawMatch.team_one_id = undefined
      rawMatch.team_two_id = undefined
      match = await api.updateMatch(rawMatch)
      commit('SET_MATCH', match)
    },
    async UPDATE_MATCH_LINEUP ({ commit, getters }, [match, team]) {
      const newTeam = await api.updateMatchLineup(match, rawTeam(team))
      if(!getters.teamMap.has(newTeam.id)) {
        commit('ADD_TEAM', newTeam)
      }
      commit('SET_MATCH_TEAM', {
        matchId: match.id,
        which: team.id === match.teamOne.id ? 0 : 1,
        teamId: newTeam.id,
      })
    },
    async DESTROY_MATCH ({ commit }, { id }) {
      await api.destroyMatch(id)
      commit('REMOVE_MATCH', { id: id })
    },

    async GET_TOURNAMENTS ({ commit }) {
      const tournaments = await api.getTournaments()
      commit('SET_TOURNAMENT_LIST', tournaments)
    },
    async CREATE_TOURNAMENT ({ commit }, tournament) {
      tournament = await api.createTournament(rawTournamentParams(tournament))
      commit('ADD_TOURNAMENT', tournament)
    },
    async UPDATE_TOURNAMENT ({ commit, dispatch, getters }, tournament) {
      const prevTournament = getters.tournamentMap.get(tournament.id)
      const prevTeams = prevTournament.teams
      const newTeams = tournament.teams
      const prevTeamIds = new Set(prevTeams.map(t => t.id))
      const newTeamIds = new Set(newTeams.map(t => t.id))
      const createTeams = [...newTeams].filter(team => !prevTeamIds.has(team.id))
      const destroyTeams = [...prevTeams].filter(team => !newTeamIds.has(team.id))
      const teamsIntersection = [...newTeams].filter(team => prevTeamIds.has(team.id))
      let promises = []
      for(const team of createTeams) {
        promises.push(api.createTournamentLineup(tournament, rawTeam(team)))
      }
      for(const team of destroyTeams) {
        promises.push(api.destroyTournamentLineup(tournament, rawTeam(team)))
      }
      for(const team of teamsIntersection) {
        const prevMemberIds = getters.teamMap.get(team.id).members.map(m => m.id)
        const newMemberIds = team.members.map(m => m.id)
        if(!_.isEqual(prevMemberIds.sort(), newMemberIds.sort())) {
          promises.push(api.updateTournamentLineup(tournament, rawTeam(team)))
        }
      }
      const updatePromise = api.updateTournament(rawTournamentParams(tournament))
      promises = [updatePromise, ...promises]
      await axios.all(promises)
      // do not use the response of updateTournament, because we don't know the order in which
      // the requests will be processed.
      commit('SET_TOURNAMENT', rawTournament(tournament))
    },
    async DESTROY_TOURNAMENT ({ commit }, { id }) {
      await api.destroyTournament(id)
      commit('REMOVE_TOURNAMENT', { id: id })
    },
    async UPDATE_TOURNAMENT_LINEUP ({ commit, getters }, [tournament, team]) {
      const newTeam = await api.updateTournamentLineup(tournament, rawTeam(team))
      if(!getters.teamMap.has(newTeam.id)) {
        commit('ADD_TEAM', newTeam)
      } else {
        commit('SET_TEAM', newTeam)
      }
      commit('SET_TOURNAMENT_TEAM', { tournamentId: tournament.id, fromTeam: team, toTeam: newTeam })
    },
    async UPDATE_TOURNAMENT_MATCH ({ commit, getters }, [tournament, match]) {
      const newMatch = await api.updateTournamentMatch(tournament, rawMatch(match))
      commit('SET_TOURNAMENT_MATCH', { tournament, match: newMatch })
      const rawTournament = await api.getTournament(tournament)
      commit('SET_TOURNAMENT', rawTournament)
    },
  },
})

export default store
