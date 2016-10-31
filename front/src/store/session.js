import api from 'src/api'
import auth from 'src/auth'
import router from 'src/router'

import {
  SET_CURRENT_USER_AND_TOKEN,
  SET_CURRENT_USER,
  RESET_CURRENT_USER_AND_TOKEN,
} from './mutation_types'

const state = {
  currentUser: null,
  sessionToken: null,
}

const getters = {
  isLoggedIn (state) {
    return state.currentUser !== null
  },
  isAdmin (state) {
    return state.currentUser && state.currentUser.role === 'admin'
  },
  currentUser (state) {
    return state.currentUser
  },
}

const mutations = {
  [SET_CURRENT_USER_AND_TOKEN] (state, { user, token }) {
    state.currentUser = user
    state.sessionToken = token
  },

  [SET_CURRENT_USER] (state, user) {
    state.currentUser = user
  },

  [RESET_CURRENT_USER_AND_TOKEN] (state) {
    state.currentUser = null
    state.sessionToken = null
  },
}

const actions = {
  async LOG_IN ({ commit, dispatch }, creds) {
    const userWithToken = await api.getUserWithToken(creds)
    commit('SET_CURRENT_USER_AND_TOKEN', userWithToken)
    auth.logIn(userWithToken)
    router.push('/')
    dispatch('GET_EVERYTHING')
  },
  LOG_OUT ({ commit }) {
    auth.logOut()
    commit('RESET_CURRENT_USER_AND_TOKEN')
  },
}

export default { state, getters, mutations, actions }
export { mutations }
