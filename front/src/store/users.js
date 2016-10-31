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

export default { state, getters, mutations }
export { mutations }
