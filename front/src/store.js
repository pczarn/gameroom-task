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
  return {
    ...enrichMatch(match),
    owner: store.getters.userMap.get(match.owner_id),
  }
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
    description: tournament.description,
    numberOfTeams: tournament.number_of_teams,
    startedAt: tournament.started_at,
    status: tournament.status,
    imageUrl: tournament.image_url,
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

function rawMatch(match) {
  return {
    id: match.id,
    played_at: match.playedAt,
    team_one_score: match.teamOneScore,
    team_two_score: match.teamTwoScore,
  }
}

function rawFriendlyMatch(match) {
  match = rawMatch(match)
  return Object.assign(match, {
    team_one_id: match.teamOne.id,
    team_two_id: match.teamTwo.id,
    game_id: match.game.id,
  })
}

function rawTournamentParams(tournament) {
  return {
    id: tournament.id,
    title: tournament.title,
    description: tournament.description,
    number_of_teams: tournament.numberOfTeams,
    started_at: tournament.startedAt,
    image_url: tournament.imageUrl,
    game_id: tournament.game.id,
  }
}

function rawTournament(tournament) {
  return {
    ...rawTournamentParams(tournament),
    status: tournament.status,
    owner_id: tournament.owner.id,
    rounds: tournament.rounds.map(matches => matches.map(rawMatch)),
    teams: tournament.teams.map(team => {
      return {
        id: team.teamTournamentId,
        team_id: team.id,
        number_of_slots: team.numberOfSlots,
      }
    }),
  }
}

function rawTeam(team) {
  return {
    id: team.id,
    name: team.name,
    member_ids: team.members.map(member => member.id),
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
    alert: '',
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
    alert (state) {
      return state.alert
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
    teamByMemberIdsMap (state, getters) {
      return new Map(getters.teamList.map(team => [team.members.map(m => m.id).sort().toString(), team]))
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

    SET_ERROR (state, alert) {
      state.alert = alert
    },

    SET_EVERYTHING (state, lists) {
      state.games = lists.games
      state.teams = lists.teams
      state.matches = lists.matches
      state.tournaments = lists.tournaments
      state.users = lists.users
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
    SET_MATCH_TEAM (state, { matchId, which, teamId }) {
      const match = state.matches.find(({ id }) => id === matchId)
      if(which === 0) {
        match.team_one_id = teamId
      } else {
        match.team_two_id = teamId
      }
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
      let teamIndex = tournament.teams.findIndex(team => team.team_id === fromTeam.id)
      Vue.set(tournament.teams[teamIndex], 'team_id', toTeam.id)
    },
    SET_TOURNAMENT_MATCH (state, { tournament, match }) {
      tournament = state.tournaments.find(({ id }) => id === tournament.id)
      for(const round of tournament.rounds) {
        const idx = round.findIndex(m => m.id === match.id)
        if(idx !== -1) {
          Vue.set(round, idx, match)
          break
        }
      }
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
      team = await api.createTeam(rawTeam(team))
      commit('ADD_TEAM', team)
      return team
    },
    async UPDATE_TEAM ({ commit }, team) {
      team = await api.updateTeam(rawTeam(team))
      commit('SET_TEAM', team)
    },

    async GET_MATCHES ({ commit }) {
      let teams = await api.getMatches()
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
      let tournaments = await api.getTournaments()
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
  }
})

export default store
