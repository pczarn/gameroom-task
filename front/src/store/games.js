import api from 'src/api'

import * as mutation from './mutation_types'
import * as action from './action_types'

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
  [mutation.SET_GAME_LIST] (state, games) {
    state.games = games
  },

  [mutation.ADD_GAME] (state, game) {
    state.games.push(game)
  },

  [mutation.SET_GAME] (state, game) {
    const idx = state.games.findIndex(({ id }) => id === game.id)
    state.games.splice(idx, 1, game)
  },

  [mutation.REMOVE_GAME] (state, game) {
    const idx = state.games.findIndex(({ id }) => id === game.id)
    state.games.splice(idx, 1)
  },
}

const actions = {
  async [action.GET_GAMES] ({ commit }) {
    const games = await api.getGames()
    commit(mutation.SET_GAME_LIST, games)
  },

  async [action.CREATE_GAME] ({ commit }, game) {
    game = await api.createGame(game)
    commit(mutation.ADD_GAME, game)
  },

  async [action.UPDATE_GAME] ({ commit }, game) {
    game = await api.updateGame(game)
    commit(mutation.SET_GAME, game)
  },

  async [action.DESTROY_GAME] ({ commit }, { id }) {
    await api.destroyGame(id)
    commit(mutation.REMOVE_GAME, { id: id })
  },
}

export default { state, getters, mutations, actions }
export { mutations }
