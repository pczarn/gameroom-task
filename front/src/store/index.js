import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

import api from 'src/api'

import session from 'src/store/session'
import teams from 'src/store/teams'
import matches from 'src/store/matches'
import games from 'src/store/games'
import tournaments from 'src/store/tournaments'
import users from 'src/store/users'
import alert from 'src/store/alert'

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
    matches,
    tournaments,
    users,
    alert,
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
  },
})

export default store
