// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import Vuex from 'vuex'
import VueRouter from 'vue-router'
import VueTimeago from 'vue-timeago'

import App from './App'
import GameList from './components/GameList'
import TeamList from './components/TeamList'
import MatchList from './components/MatchList'
import TournamentList from './components/TournamentList'
import Tournament from './components/Tournament'
import Match from './components/Match'
import Login from './components/Login'
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
    redirect: '/games',
  },
  {
    path: '/games',
    component: GameList,
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
    path: '/tournaments/:id',
    component: Tournament,
  },
  {
    path: '/matches/:id',
    component: Match,
  },
]

export var router = new VueRouter({
  routes
})

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
    userMatches (state) {
      if(state.currentUser) {
        let userId = state.currentUser.id
        return state.matches.map(match => match.team_one + match.team_two)
                            .filter(members => members.includes(userId))
      } else {
        return []
      }
    },
    userList (state) {
      return state.users
    },
    userMap (state) {
      return new Map(state.users.map(user => [user.id, user]))
    },
    gameList (state) {
      return state.games
    },
    teamList (state) {
      return state.teams
    },
    matchList (state) {
      return state.matches
    },
    tournamentList (state) {
      return state.tournaments
    },
    activeGames (state) {
      return state.games.filter(game => !game.archivized)
    },
    archivizedGames (state) {
      return state.games.filter(game => game.archivized)
    },
  },
  mutations: {
    SET_CURRENT_USER (state, { user, token }) {
      state.currentUser = user
      state.sessionToken = token
    },
    RESET_CURRENT_USER (state) {
      state.currentUser = null
      state.sessionToken = null
    },

    SET_USER_LIST (state, users) {
      state.users = users
    },

    SET_GAME_LIST (state, games) {
      state.games = games
    },
    ADD_GAME (state, game) {
      state.games.push(game)
    },
    SET_GAME (state, game) {
      let idx = state.games.findIndex(({ id }) => id == game.id)
      state.games[idx] = game
    },
    REMOVE_GAME (state, game) {
      let idx = state.games.findIndex(({ id }) => id == game.id)
      state.games.splice(idx, 1)
    },

    SET_TEAM_LIST (state, teams) {
      state.teams = teams
    },
    ADD_TEAM (state, team) {
      state.teams.push(team)
    },
    SET_TEAM (state, team) {
      let idx = state.teams.findIndex(({ id }) => id == team.id)
      state.teams[idx] = team
    },

    SET_MATCH_LIST (state, matches) {
      state.matches = matches
    },
    ADD_MATCH (state, match) {
      state.matches.push(match)
    },
    SET_MATCH (state, match) {
      let idx = state.matches.findIndex(({ id }) => id == match.id)
      Vue.set(state.matches, idx, match)
    },
    REMOVE_MATCH (state, match) {
      let idx = state.matches.findIndex(({ id }) => id == match.id)
      state.matches.splice(idx, 1)
    },

    SET_TOURNAMENT_LIST (state, tournaments) {
      state.tournaments = tournaments
    },
    ADD_TOURNAMENT (state, tournament) {
      state.tournaments.push(tournament)
    },
    SET_TOURNAMENT (state, tournament) {
      let idx = state.tournaments.findIndex(({ id }) => id == tournament.id)
      state.tournaments[idx] = tournament
    },
    REMOVE_TOURNAMENT (state, tournament) {
      let idx = state.tournaments.findIndex(({ id }) => id == tournament.id)
      state.tournaments.splice(idx, 1)
    },

    ADD_TEAM_TO_TOURNAMENT (state, { tournamentId, teamId }) {
      let tournament = state.tournaments.find(({ id }) => id == tournamentId)
      let team = state.teams.find(({ id }) => id == teamId)
      tournament.teams.push(team)
    },
    REMOVE_TEAM_FROM_TOURNAMENT (state, { tournamentId, teamId }) {
      let tournament = state.tournaments.find(({ id }) => id == tournamentId)
      let teamIndex = tournament.teams.findIndex(({ id }) => id == fromTeamId)
      tournament.teams.splice(teamIndex, 1)
    },
    SET_TOURNAMENT_TEAM (state, { tournamentId, fromTeamId, toTeamId }) {
      let tournament = state.tournaments.find(({ id }) => id == tournamentId)
      let teamIndex = tournament.teams.findIndex(({ id }) => id == fromTeamId)
      let toTeam = state.teams.find(({ id }) => id == toTeamId)
      tournament.teams[teamIndex] = toTeam
    },
  },
  actions: {
    async LOG_IN ({ commit }, creds) {
      let userWithToken = await api.getUserWithToken(creds)
      commit('SET_CURRENT_USER', userWithToken)
      auth.logIn(userWithToken)
      router.push('/')
    },
    LOG_OUT ({ commit }) {
      auth.logOut()
      commit('RESET_CURRENT_USER')
    },

    async GET_USERS ({ commit }) {
      let users = await api.getUsers()
      commit('SET_USER_LIST', users)
    },
    async CREATE_USER ({ dispatch }, userParams) {
      let user = await api.createUser(userParams)
      dispatch('LOG_IN', { email: user.email, password: user.password })
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
    async UPDATE_MATCH ({ commit }, match) {
      match = await api.updateMatch(match)
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
    async UPDATE_TOURNAMENT ({ commit }, tournament) {
      tournament = await api.updateTournament(tournament)
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
  } else if(!store.getters.isLoggedIn) {
    next('/login')
  } else {
    next()
  }
})

new Vue({
  router,
  store,
  render: h => h(App),
  data () {
    return {}
  },
  async beforeMount () {
    let token = auth.getToken()
    let redirectToLogin
    if(token) {
      try {
        api.logIn(token)
        let currentUser = auth.getCurrentUser()
        this.$store.commit('SET_CURRENT_USER', { user: currentUser, token: token })
      } catch(err) {
        auth.logOut()
        redirectToLogin = true
      }
    } else {
      redirectToLogin = true
    }

    if(redirectToLogin) {
      this.$router.push('/login')
    } else {
      this.$store.dispatch('GET_GAMES')
      this.$store.dispatch('GET_TEAMS')
      this.$store.dispatch('GET_MATCHES')
      this.$store.dispatch('GET_TOURNAMENTS')
      this.$store.dispatch('GET_USERS')
    }
  },
}).$mount('#app')
