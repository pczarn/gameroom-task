import api from 'src/api'
import auth from 'src/auth'
import router from 'src/router'

import * as mutation from './mutation_types'
import * as action from './action_types'

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
  [mutation.SET_CURRENT_USER_AND_TOKEN] (state, { user, token }) {
    state.currentUser = user
    state.sessionToken = token
  },

  [mutation.SET_CURRENT_USER] (state, user) {
    state.currentUser = user
  },

  [mutation.RESET_CURRENT_USER_AND_TOKEN] (state) {
    state.currentUser = null
    state.sessionToken = null
  },
}

const actions = {
  async [action.LOG_IN] ({ commit, dispatch }, creds) {
    const userWithToken = await api.getUserWithToken(creds)
    commit(mutation.SET_CURRENT_USER_AND_TOKEN, userWithToken)
    auth.logIn(userWithToken)
    router.push('/')
    dispatch(action.GET_EVERYTHING)
  },
  [action.LOG_OUT] ({ commit }) {
    auth.logOut()
    commit(mutation.RESET_CURRENT_USER_AND_TOKEN)
  },
}

export default { state, getters, mutations, actions }
export { mutations }
