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

export default { state, getters, mutations }
export { mutations }
