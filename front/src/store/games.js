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

export default { state, getters, mutations }
export { mutations }
