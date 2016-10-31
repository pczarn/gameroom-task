import {
  SET_MATCH_LIST,
  ADD_MATCH,
  SET_MATCH,
  REMOVE_MATCH,
  SET_MATCH_TEAM,
} from './mutation_types'
import { enrichFriendlyMatch } from 'src/store/mapping'

const state = {
  matches: [],
}

const getters = {
  rawMatchList (state) {
    return state.matches
  },

  matchList (state, getters) {
    return getters.rawMatchList.map(enrichFriendlyMatch)
  },

  matchMap (state, getters) {
    return new Map(getters.matchList.map(match => [match.id, match]))
  },
}

const mutations = {
  [SET_MATCH_LIST] (state, matches) {
    state.matches = matches
  },

  [ADD_MATCH] (state, match) {
    state.matches.push(match)
  },

  [SET_MATCH] (state, match) {
    const idx = state.matches.findIndex(({ id }) => id === match.id)
    state.matches.splice(idx, 1, match)
  },

  [REMOVE_MATCH] (state, match) {
    const idx = state.matches.findIndex(({ id }) => id === match.id)
    state.matches.splice(idx, 1)
  },

  [SET_MATCH_TEAM] (state, { matchId, which, teamId }) {
    const match = state.matches.find(({ id }) => id === matchId)
    if(which === 0) {
      match.team_one_id = teamId
    } else {
      match.team_two_id = teamId
    }
  },
}

export default { state, getters, mutations }
export { mutations }
