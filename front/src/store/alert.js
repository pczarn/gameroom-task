import {
  SET_ERROR,
} from './mutation_types'

const state = {
  text: '',
}

const getters = {
  alert (state) {
    return state.text
  },
}

const mutations = {
  [SET_ERROR] (state, alert) {
    state.text = alert
  },
}

const actions = {
  SET_ERROR ({ commit }, alert) {
    commit('SET_ERROR', alert)
  },
}

export default { state, getters, mutations, actions }
export { mutations }
