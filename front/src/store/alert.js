import * as mutation from './mutation_types'
import * as action from './action_types'

const state = {
  text: '',
}

const getters = {
  alert (state) {
    return state.text
  },
}

const mutations = {
  [mutation.SET_ERROR] (state, alert) {
    state.text = alert
  },
}

const actions = {
  [action.SET_ERROR] ({ commit }, alert) {
    commit(mutation.SET_ERROR, alert)
  },
}

export default { state, getters, mutations, actions }
export { mutations }
