import api from 'src/api'
import _ from 'lodash'

import {
  SET_USER_LIST,
  SET_USER,
} from './mutation_types'

const state = {
  users: [],
}

const getters = {
  userList (state) {
    return state.users
  },

  userMap (state, getters) {
    return new Map(getters.userList.map(user => [user.id, user]))
  },
}

const mutations = {
  [SET_USER_LIST] (state, users) {
    state.users = users
  },

  [SET_USER] (state, user) {
    const idx = state.users.findIndex(({ id }) => id === user.id)
    state.users.splice(idx, 1, user)
  },
}

const actions = {
  async GET_USERS ({ commit }) {
    const users = await api.getUsers()
    commit('SET_USER_LIST', users)
  },
  async CREATE_USER ({ dispatch }, userParams) {
    await api.createUser(userParams)
    dispatch('LOG_IN', { email: userParams.email, password: userParams.password })
  },
  async UPDATE_USER ({ commit, getters }, userParams) {
    const user = await api.updateUser(userParams)
    commit('SET_USER', user)
    if(getters.currentUser && user.id === getters.currentUser.id) {
      commit('SET_CURRENT_USER', user)
    }
  },
}

export default { state, getters, mutations, actions }
export { mutations }
