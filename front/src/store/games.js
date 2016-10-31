import api from 'src/api'
import {
  SET_GAME_LIST,
  ADD_GAME,
  SET_GAME,
  REMOVE_GAME,
} from './mutation_types'

const state = {
  games: [],
}

const getters = {
  gameList (state, getters) {
    return state.games
  },

  gameMap (state, getters) {
    return new Map(getters.gameList.map(game => [game.id, game]))
  },

  activeGames (state) {
    return state.games.filter(game => !game.archivized)
  },

  archivizedGames (state) {
    return state.games.filter(game => game.archivized)
  },
}

const mutations = {
  [SET_GAME_LIST] (state, games) {
    state.games = games
  },

  [ADD_GAME] (state, game) {
    state.games.push(game)
  },

  [SET_GAME] (state, game) {
    const idx = state.games.findIndex(({ id }) => id === game.id)
    state.games.splice(idx, 1, game)
  },

  [REMOVE_GAME] (state, game) {
    const idx = state.games.findIndex(({ id }) => id === game.id)
    state.games.splice(idx, 1)
  },
}

const actions = {
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
}

export default { state, getters, mutations, actions }
export { mutations }
