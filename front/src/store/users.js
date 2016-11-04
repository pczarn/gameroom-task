import api from 'src/api'

import * as mutation from './mutation_types'
import * as action from './action_types'

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
  [mutation.SET_USER_LIST] (state, users) {
    state.users = users
  },

  [mutation.SET_USER] (state, user) {
    const idx = state.users.findIndex(({ id }) => id === user.id)
    state.users.splice(idx, 1, user)
  },
}

const actions = {
  async [action.GET_USERS] ({ commit }) {
    const users = await api.getUsers()
    commit(mutation.SET_USER_LIST, users)
  },
  async [action.CREATE_USER] ({ dispatch }, userParams) {
    await api.createUser(userParams)
    dispatch(action.LOG_IN, { email: userParams.email, password: userParams.password })
  },
  async [action.UPDATE_USER] ({ commit, getters }, userParams) {
    const user = await api.updateUser(userParams)
    commit(mutation.SET_USER, user)
    if(getters.currentUser && user.id === getters.currentUser.id) {
      commit(mutation.SET_CURRENT_USER, user)
    }
  },
}

export default { state, getters, mutations, actions }
export { mutations }
