import api from 'src/api'

import {
  SET_TEAM_LIST,
  ADD_TEAM,
  SET_TEAM,
} from './mutation_types'
import { enrichTeam, rawTeam } from 'src/store/mapping'

const state = {
  teams: [],
}

const getters = {
  rawTeamList (state) {
    return state.teams
  },

  teamList (state, getters) {
    return getters.rawTeamList.map(enrichTeam)
  },

  teamMap (state, getters) {
    return new Map(getters.teamList.map(team => [team.id, team]))
  },

  teamByMemberIdsMap (state, getters) {
    return new Map(getters.teamList.map(team => [team.members.map(m => m.id).sort().toString(), team]))
  },
}

const mutations = {
  [SET_TEAM_LIST] (state, teams) {
    state.teams = teams
  },

  [ADD_TEAM] (state, team) {
    state.teams.push(team)
  },

  [SET_TEAM] (state, team) {
    const idx = state.teams.findIndex(({ id }) => id === team.id)
    state.teams.splice(idx, 1, team)
  },
}

const actions = {
  async GET_TEAMS ({ commit }) {
    const teams = await api.getTeams()
    commit('SET_TEAM_LIST', teams)
  },
  async CREATE_TEAM ({ commit }, team) {
    team = await api.createTeam(rawTeam(team))
    commit('ADD_TEAM', team)
    return team
  },
  async UPDATE_TEAM ({ commit }, team) {
    team = await api.updateTeam(rawTeam(team))
    commit('SET_TEAM', team)
  },
}

export default { state, getters, mutations, actions }
export { mutations }
