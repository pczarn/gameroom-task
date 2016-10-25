import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'
import _ from 'lodash'

import api from 'src/api'
import auth from 'src/auth'
import router from 'src/router'

Vue.use(Vuex)

function enrichMatch(match) {
  return {
    id: match.id,
    playedAt: match.played_at,
    teamOneScore: match.team_one_score,
    teamTwoScore: match.team_two_score,
    teamOne: store.getters.teamMap.get(match.team_one_id),
    teamTwo: store.getters.teamMap.get(match.team_two_id),
    game: store.getters.gameMap.get(match.game_id),
  }
}

function enrichFriendlyMatch(match) {
  match = enrichMatch(match)
  match.owner = store.getters.userMap.get(match.owner_id)
  return match
}

function enrichTournament(tournament) {
  const teams = tournament.teams.map(teamTournament => {
    const team = store.getters.teamMap.get(teamTournament.team_id)
    return {
      id: teamTournament.team_id,
      numberOfSlots: teamTournament.number_of_slots,
      teamTournamentId: teamTournament.id,
      name: team.name,
      members: team.members,
    }
  })
  return {
    id: tournament.id,
    title: tournament.title,
    started_at: tournament.started_at,
    status: tournament.status,
    image_url: tournament.image_url,
    owner: store.getters.userMap.get(tournament.owner_id),
    game: store.getters.gameMap.get(tournament.game_id),
    rounds: tournament.rounds.map(matches => matches.map(enrichMatch)),
    teams,
  }
}

function enrichTeam(team) {
  return {
    id: team.id,
    name: team.name,
    members: team.member_ids.map(memberId => store.getters.userMap.get(memberId)),
  }
}

export const store = new Vuex.Store({
  state: {
    currentUser: null,
    games: [],
    teams: [],
    matches: [],
    tournaments: [],
    users: [],
  },
  getters: {
    isLoggedIn (state) {
      return state.currentUser !== null
    },
    isAdmin (state) {
      return state.currentUser && state.currentUser.role === 'admin'
    },
    currentUser (state) {
      return state.currentUser
    },

    userList (state) {
      return state.users
    },
    userMap (state, getters) {
      return new Map(getters.userList.map(user => [user.id, user]))
    },

    gameList (state, getters) {
      return state.games
    },
    gameMap (state, getters) {
      return new Map(getters.gameList.map(game => [game.id, game]))
    },

    rawTeamList (state) {
      return state.teams
    },
    teamList (state, getters) {
      return getters.rawTeamList.map(enrichTeam)
    },
    teamMap (state, getters) {
      return new Map(getters.teamList.map(team => [team.id, team]))
    },

    rawMatchList (state) {
      return state.matches
    },
    matchList (state, getters) {
      return getters.rawMatchList.map(enrichFriendlyMatch)
    },
    matchMap (state, getters) {
      return new Map(getters.matchList.map(match => [match.id, match]))
    },

    // need or not?
    userMatches (state, getters) {
      if(!state.currentUser) return []
      let userId = state.currentUser.id
      return getters.matchList.map(match => match.teamOne.member_ids + match.teamTwo.member_ids)
                              .filter(memberIds => memberIds.includes(userId))
    },

    rawTournamentList (state) {
      return state.tournaments
    },
    tournamentList (state, getters) {
      return getters.rawTournamentList.map(enrichTournament)
    },
    tournamentMap (state, getters) {
      return new Map(getters.tournamentList.map(tournament => [tournament.id, tournament]))
    },

    activeGames (state) {
      return state.games.filter(game => !game.archivized)
    },
    archivizedGames (state) {
      return state.games.filter(game => game.archivized)
    },
  },
  mutations: {
    SET_CURRENT_USER_AND_TOKEN (state, { user, token }) {
      state.currentUser = user
      state.sessionToken = token
    },
    SET_CURRENT_USER (state, user) {
      state.currentUser = user
    },
    RESET_CURRENT_USER_AND_TOKEN (state) {
      state.currentUser = null
      state.sessionToken = null
    },

    SET_USER_LIST (state, users) {
      state.users = users
    },
    SET_USER (state, user) {
      let idx = state.users.findIndex(({ id }) => id === user.id)
      state.users.splice(idx, 1, user)
    },

    SET_GAME_LIST (state, games) {
      state.games = games
    },
    ADD_GAME (state, game) {
      state.games.push(game)
    },
    SET_GAME (state, game) {
      let idx = state.games.findIndex(({ id }) => id === game.id)
      state.games.splice(idx, 1, game)
    },
    REMOVE_GAME (state, game) {
      let idx = state.games.findIndex(({ id }) => id === game.id)
      state.games.splice(idx, 1)
    },

    SET_TEAM_LIST (state, teams) {
      state.teams = teams
    },
    ADD_TEAM (state, team) {
      state.teams.push(team)
    },
    SET_TEAM (state, team) {
      let idx = state.teams.findIndex(({ id }) => id === team.id)
      state.teams.splice(idx, 1, team)
    },

    SET_MATCH_LIST (state, matches) {
      state.matches = matches
    },
    ADD_MATCH (state, match) {
      state.matches.push(match)
    },
    SET_MATCH (state, match) {
      let idx = state.matches.findIndex(({ id }) => id === match.id)
      state.matches.splice(idx, 1, match)
    },
    REMOVE_MATCH (state, match) {
      let idx = state.matches.findIndex(({ id }) => id === match.id)
      state.matches.splice(idx, 1)
    },

    SET_TOURNAMENT_LIST (state, tournaments) {
      state.tournaments = tournaments
    },
    ADD_TOURNAMENT (state, tournament) {
      state.tournaments.push(tournament)
    },
    SET_TOURNAMENT (state, tournament) {
      let idx = state.tournaments.findIndex(({ id }) => id === tournament.id)
      state.tournaments.splice(idx, 1, tournament)
    },
    REMOVE_TOURNAMENT (state, tournament) {
      let idx = state.tournaments.findIndex(({ id }) => id === tournament.id)
      state.tournaments.splice(idx, 1)
    },

    ADD_TEAM_TO_TOURNAMENT (state, { tournamentId, teamId }) {
      let tournament = state.tournaments.find(({ id }) => id === tournamentId)
      let team = state.teams.find(({ id }) => id === teamId)
      tournament.teams.push(team)
    },
    REMOVE_TEAM_FROM_TOURNAMENT (state, { tournamentId, teamId }) {
      let tournament = state.tournaments.find(({ id }) => id === tournamentId)
      let teamIndex = tournament.teams.findIndex(({ id }) => id === teamId)
      tournament.teams.splice(teamIndex, 1)
    },
    SET_TOURNAMENT_TEAM (state, { tournamentId, fromTeam, toTeam }) {
      let tournament = state.tournaments.find(({ id }) => id === tournamentId)
      let teamIndex = tournament.teams.findIndex(({ id }) => id === fromTeam.id)
      tournament.teams.splice(teamIndex, 1, toTeam)
    },
  },
  actions: {
    async LOG_IN ({ commit, dispatch }, creds) {
      let userWithToken = await api.getUserWithToken(creds)
      commit('SET_CURRENT_USER_AND_TOKEN', userWithToken)
      auth.logIn(userWithToken)
      router.push('/')
      dispatch('GET_EVERYTHING')
    },
    LOG_OUT ({ commit }) {
      auth.logOut()
      commit('RESET_CURRENT_USER_AND_TOKEN')
    },

    GET_EVERYTHING ({ dispatch }) {
      dispatch('GET_GAMES')
      dispatch('GET_TEAMS')
      dispatch('GET_MATCHES')
      dispatch('GET_TOURNAMENTS')
      dispatch('GET_USERS')
    },

    async GET_USERS ({ commit }) {
      let users = await api.getUsers()
      commit('SET_USER_LIST', users)
    },
    async CREATE_USER ({ dispatch }, userParams) {
      await api.createUser(userParams)
      dispatch('LOG_IN', { email: userParams.email, password: userParams.password })
    },
    async UPDATE_USER ({ commit, getters }, userParams) {
      let user = await api.updateUser(userParams)
      commit('SET_USER', user)
      if(getters.currentUser && user.id === getters.currentUser.id) {
        commit('SET_CURRENT_USER', user)
      }
    },

    async GET_GAMES ({ commit }) {
      let games = await api.getGames()
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
      let teams = await api.getTeams()
      commit('SET_TEAM_LIST', teams)
    },
    async CREATE_TEAM ({ commit }, team) {
      team = await api.createTeam(team)
      commit('ADD_TEAM', team)
      return team
    },
    async UPDATE_TEAM ({ commit }, team) {
      team = await api.updateTeam(team)
      commit('SET_TEAM', team)
    },

    async GET_MATCHES ({ commit }) {
      let teams = await api.getMatches()
      commit('SET_MATCH_LIST', teams)
    },
    async CREATE_MATCH ({ commit }, match) {
      match = await api.createMatch(match)
      commit('ADD_MATCH', match)
    },
    async UPDATE_MATCH ({ commit, dispatch, getters }, match) {
      const teamOneMemberIds = match.teamOne.members.map(m => m.id).sort()
      const teamTwoMemberIds = match.teamTwo.members.map(m => m.id).sort()
      const currentMatch = getters.matchMap.get(match.id)
      if(!_.isEqual(teamOneMemberIds, currentMatch.teamOne.member_ids.concat().sort())) {
        match.teamOne.member_ids = teamOneMemberIds
        dispatch('UPDATE_MATCH_LINEUP', [match, match.teamOne])
      }
      if(!_.isEqual(teamTwoMemberIds, currentMatch.teamTwo.member_ids.concat().sort())) {
        match.teamTwo.member_ids = teamTwoMemberIds
        dispatch('UPDATE_MATCH_LINEUP', [match, match.teamTwo])
      }
      match.team_one_id = undefined
      match.team_two_id = undefined
      match = await api.updateMatch(match)
      commit('SET_MATCH', match)
    },
    async UPDATE_MATCH_LINEUP ({ commit, getters }, [match, team]) {
      const newTeam = await api.updateMatchLineup(match, team)
      if(!getters.teamMap.has(newTeam.id)) {
        commit('ADD_TEAM', newTeam)
      }
      match = getters.matchMap.get(match.id)
      if(team.id === match.team_one_id) {
        match.team_one_id = newTeam.id
      } else {
        match.team_two_id = newTeam.id
      }
      commit('SET_MATCH', match)
    },
    async DESTROY_MATCH ({ commit }, { id }) {
      await api.destroyMatch(id)
      commit('REMOVE_MATCH', { id: id })
    },

    async GET_TOURNAMENTS ({ commit }) {
      let tournaments = await api.getTournaments()
      commit('SET_TOURNAMENT_LIST', tournaments)
    },
    async CREATE_TOURNAMENT ({ commit }, tournament) {
      tournament = await api.createTournament(tournament)
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
        promises.push(api.createTournamentLineup(tournament, team))
        // dispatch('CREATE_TOURNAMENT_LINEUP', tournament, team)
      }
      for(const team of destroyTeams) {
        promises.push(api.destroyTournamentLineup(tournament, team))
        // dispatch('DESTROY_TOURNAMENT_LINEUP', tournament, team)
      }
      for(const team of teamsIntersection) {
        const prevMemberIds = getters.teamMap.get(team.id).members.map(m => m.id)
        const newMemberIds = team.members.map(m => m.id)
        if(!_.isEqual(prevMemberIds.sort(), newMemberIds.sort())) {
          promises.push(api.updateTournamentLineup(tournament, team))
          // dispatch('UPDATE_TOURNAMENT_LINEUP', tournament, team)
        }
      }
      promises = [api.updateTournament(tournament), ...promises]
      await axios.all(promises)
      // do not use the response of updateTournament, because we don't know the order in which
      // the requests will be processed.
      commit('SET_TOURNAMENT', tournament)
    },
    async DESTROY_TOURNAMENT ({ commit }, { id }) {
      await api.destroyTournament(id)
      commit('REMOVE_TOURNAMENT', { id: id })
    },
    async UPDATE_TOURNAMENT_LINEUP ({ commit, getters }, [tournament, team]) {
      const newTeam = await api.updateTournamentLineup(tournament, team)
      if(!getters.teamMap.has(newTeam.id)) {
        commit('ADD_TEAM', newTeam)
      }
      commit('SET_TOURNAMENT_TEAM', { tournament, fromTeam: team, toTeam: newTeam })
    },

    async ADD_TEAM_TO_TOURNAMENT ({ commit }, { tournament, team }) {
      await api.createTournamentTeamParticipation(tournament.id, { id: team.id })
      commit('ADD_TEAM_TO_TOURNAMENT', { tournamentId: tournament.id, teamId: team.id })
    },
    async CREATE_AND_ADD_TEAM_TO_TOURNAMENT ({ commit }, { tournament, team }) {
      await api.createTournamentTeamParticipation(tournament.id, { member_ids: team.member_ids })
      commit('ADD_TEAM', team)
      commit('ADD_TEAM_TO_TOURNAMENT', { tournamentId: tournament.id, teamId: team.id })
    },
    async REMOVE_TEAM_FROM_TOURNAMENT ({ commit }, { tournamentId, team }) {
      await api.destroyTournamentTeamParticipation(tournamentId, team.id)
      commit('REMOVE_TEAM_FROM_TOURNAMENT', { tournamentId, teamId: team.id })
    },
  }
})

export default store