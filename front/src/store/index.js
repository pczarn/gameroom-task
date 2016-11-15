import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'
import _ from 'lodash'

import api from 'src/api'

import session from 'src/store/session'
import teams from 'src/store/teams'
import friendlyMatches from 'src/store/friendly_matches'
import games from 'src/store/games'
import tournaments from 'src/store/tournaments'
import users from 'src/store/users'
import alert from 'src/store/alert'

import {
  SET_EVERYTHING,
  SET_FORM_ERRORS,
} from './mutation_types'

import {
  GET_EVERYTHING,
  CLEAR_FORM_ERRORS,
} from './action_types'

Vue.use(Vuex)

function getIdIfMatched(route, routeName) {
  const id = parseInt(route.params.id)
  if(id && route.name.startsWith(routeName)) {
    return id
  }
}

export const store = new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production',
  modules: {
    session,
    games,
    teams,
    friendlyMatches,
    tournaments,
    users,
    alert,
  },
  state: {
    formErrors: {},
  },
  getters: {
    currentMatch (state, getters) {
      const id = getIdIfMatched(state.route, 'match')
      if(id) {
        return getters.matchMap.get(id)
      }
    },
    currentGame (state, getters) {
      const id = getIdIfMatched(state.route, 'game')
      if(id) {
        return getters.gameMap.get(id)
      }
    },
    currentTournament (state, getters) {
      const id = getIdIfMatched(state.route, 'tournament')
      if(id) {
        return getters.tournamentMap.get(id)
      }
    },
    currentTeam (state, getters) {
      const id = getIdIfMatched(state.route, 'team')
      if(id) {
        return getters.teamMap.get(id)
      }
    },
    filterUser (state, getters) {
      if(state.route.path.startsWith('/dashboard')) {
        return getters.currentUser
      }
    },
    formErrors (state) {
      return state.formErrors
    },
  },
  mutations: {
    [SET_EVERYTHING] (state, lists) {
      state.games.games = lists.games
      state.teams.teams = lists.teams
      state.friendlyMatches.matches = lists.friendlyMatches
      state.tournaments.tournaments = lists.tournaments
      state.users.users = lists.users
    },
    [SET_FORM_ERRORS] (state, formErrors) {
      state.formErrors = formErrors
    }
  },
  actions: {
    async [GET_EVERYTHING] ({ commit }) {
      const lists = await axios.all([
        api.getGames(),
        api.getTeams(),
        api.getFriendlyMatches(),
        api.getTournaments(),
        api.getUsers(),
      ])
      commit(SET_EVERYTHING, {
        games: lists[0],
        teams: lists[1],
        friendlyMatches: lists[2],
        tournaments: lists[3],
        users: lists[4],
      })
    },
    [CLEAR_FORM_ERRORS] ({ commit, getters }) {
      if(!_.isEmpty(getters.formErrors)) {
        commit(SET_FORM_ERRORS, {})
      }
    },
  },
})

export default store
