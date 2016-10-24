// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import Vuex from 'vuex'
import VueRouter from 'vue-router'
import VueTimeago from 'vue-timeago'
import axios from 'axios'

import App from './App'
import GameList from './components/GameList'
import Game from './components/Game'
import TeamList from './components/TeamList'
import MatchList from './components/MatchList'
import TournamentList from './components/TournamentList'
import Tournament from './components/Tournament'
import Match from './components/Match'
import Login from './components/Login'
import Dashboard from './components/Dashboard'
import Team from './components/Team'
import Account from './components/Account'
import auth from './auth'
import api from './api'

Vue.use(Vuex)
Vue.use(VueRouter)

Vue.use(VueTimeago, {
  name: 'timeago',
  locale: 'en-US',
  locales: {
    'en-US': require('vue-timeago/locales/en-US.json')
  },
})

const routes = [
  {
    path: '/',
    redirect: '/dashboard',
  },
  {
    path: '/dashboard',
    component: Dashboard,
    redirect: '/dashboard/tournaments',
    children: [
      {
        path: 'tournaments',
        component: TournamentList,
      },
      {
        path: 'matches',
        component: MatchList,
      },
    ],
  },
  {
    path: '/account',
    component: Account,
  },
  {
    path: '/games',
    component: GameList,
  },
  {
    path: '/games/:id',
    name: 'games',
    component: Game,
    redirect: '/games/:id/tournaments',
    children: [
      {
        path: 'tournaments',
        name: 'game tournaments',
        component: TournamentList,
      },
      {
        path: 'matches',
        name: 'game matches',
        component: MatchList,
      },
    ],
    // component: resolve => require(['./components/GameList'], resolve)
  },
  {
    path: '/teams',
    component: TeamList,
  },
  {
    path: '/matches',
    component: MatchList,
  },
  {
    path: '/tournaments',
    component: TournamentList,
    // component: resolve => require(['./components/TournamentList', './components/Tournament'], resolve)
  },
  {
    path: '/tournaments/:id',
    name: 'tournament',
    component: Tournament,
  },
  {
    path: '/login',
    component: Login,
  },
  {
    path: '/logout',
    redirect: '/login',
  },
  {
    path: '/matches/:id',
    name: 'match',
    component: Match,
  },
  {
    path: '/teams/:id',
    name: 'team',
    component: Team,
  },
]

export var router = new VueRouter({
  routes
})

function enrichMatch(match, getters) {
  return Vue.util.extend(match, {
    teamOne: getters.teamMap.get(match.team_one_id),
    teamTwo: getters.teamMap.get(match.team_two_id),
    game: getters.gameMap.get(match.game_id),
  })
}

function enrichFriendlyMatch(match, getters) {
  match = enrichMatch(match, getters)
  match.owner = getters.userMap.get(match.owner_id)
  return match
}

export var store = new Vuex.Store({
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

    // rawGameList (state) {
    // },
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
      return getters.rawTeamList.map(team => {
        return Vue.util.extend(team, {
          members: team.member_ids.map(memberId => getters.userMap.get(memberId))
        })
      })
    },
    teamMap (state, getters) {
      return new Map(getters.teamList.map(team => [team.id, team]))
    },

    rawMatchList (state) {
      return state.matches
    },
    matchList (state, getters) {
      return getters.rawMatchList.map(match => enrichFriendlyMatch(match, getters))
    },
    matchMap (state, getters) {
      return new Map(getters.matchList.map(match => [match.id, match]))
    },

    // need or not?
    userMatches (state) {
      if(!state.currentUser) return []
      let userId = state.currentUser.id
      return getters.matchList.map(match => match.teamOne.member_ids + match.teamTwo.member_ids)
                              .filter(memberIds => memberIds.includes(userId))
    },

    rawTournamentList (state) {
      return state.tournaments
    },
    tournamentList (state, getters) {
      let toRichMatch = match => enrichMatch(match, getters)
      let toListOfRichMatches = matches => matches.map(toRichMatch)
      return getters.rawTournamentList.map(tournament => {
        tournament = Vue.util.extend({}, tournament)
        tournament.owner = getters.userMap.get(tournament.owner_id)
        console.log(tournament)
        tournament.rounds = tournament.rounds.map(toListOfRichMatches)
        tournament.teams = tournament.teams.map(teamTournament => {
          let team = getters.teamMap.get(teamTournament.team_id)
          return Vue.util.extend(teamTournament, {
            id: teamTournament.team_id,
            team_tournament_id: teamTournament.id,
            name: team.name,
            member_ids: team.member_ids,
            members: team.members,
          })
        })
        return tournament
      })
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
      state.games.$set(idx, game)
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
      state.teams.$set(idx, team)
    },

    SET_MATCH_LIST (state, matches) {
      state.matches = matches
    },
    ADD_MATCH (state, match) {
      state.matches.push(match)
    },
    SET_MATCH (state, match) {
      let idx = state.matches.findIndex(({ id }) => id === match.id)
      state.matches.$set(idx, match)
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
      state.tournaments.$set(idx, tournament)
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
      let teamIndex = tournament.teams.findIndex(({ id }) => id === fromTeamId)
      tournament.teams.splice(teamIndex, 1)
    },
    SET_TOURNAMENT_TEAM (state, { tournamentId, fromTeamId, toTeamId }) {
      let tournament = state.tournaments.find(({ id }) => id === tournamentId)
      let teamIndex = tournament.teams.findIndex(({ id }) => id === fromTeamId)
      let toTeam = state.teams.find(({ id }) => id === toTeamId)
      tournament.teams.$set(teamIndex, toTeam)
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
      if(teamOneMemberIds !== currentMatch.teamOne.member_ids.sort()) {
        this.newMatch.teamOne.member_ids = teamOneMemberIds
        dispatch('UPDATE_MATCH_LINEUP', match, match.teamOne)
      }
      if(teamTwoMemberIds !== currentMatch.teamTwo.member_ids.sort()) {
        this.newMatch.teamTwo.member_ids = teamTwoMemberIds
        dispatch('UPDATE_MATCH_LINEUP', match, match.teamTwo)
      }
      match = await api.updateMatch(match)
      commit('SET_MATCH', match)
    },
    async UPDATE_MATCH_LINEUP ({ commit, getters }, match, team) {
      const newTeam = await api.updateMatchLineup(match, team)
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
        const prevMemberIds = getters.teamMap.get(team.id).member_ids
        const newMemberIds = team.members.map(m => m.id)
        if(prevMemberIds.sort() !== newMemberIds.sort()) {
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

router.beforeEach((to, from, next) => {
  if(to.path === '/login') {
    if(store.getters.isLoggedIn) {
      next('/')
    } else {
      next()
    }
  } else if(!store.getters.isLoggedIn && !auth.getToken()) {
    next('/login')
  } else {
    next()
  }
})

new Vue({
  router,
  store,
  render: h => h(App),
  beforeMount () {
    let token = auth.getToken()
    if(token) {
      api.logIn(token)
      let currentUser = auth.getCurrentUser()
      this.$store.commit('SET_CURRENT_USER_AND_TOKEN', { user: currentUser, token: token })
      this.$store.dispatch('GET_EVERYTHING')
    } else {
      this.$router.push('/login')
    }
  },
}).$mount('#app')
