import api from 'src/api'
import _ from 'lodash'

import * as mutation from './mutation_types'
import * as action from './action_types'
import { enrichFriendlyMatch, rawFriendlyMatch, rawTeam } from 'src/store/mapping'

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
  [mutation.SET_MATCH_LIST] (state, matches) {
    state.matches = matches
  },

  [mutation.ADD_MATCH] (state, match) {
    state.matches.push(match)
  },

  [mutation.SET_MATCH] (state, match) {
    const idx = state.matches.findIndex(({ id }) => id === match.id)
    state.matches.splice(idx, 1, match)
  },

  [mutation.REMOVE_MATCH] (state, match) {
    const idx = state.matches.findIndex(({ id }) => id === match.id)
    state.matches.splice(idx, 1)
  },

  [mutation.SET_MATCH_TEAM] (state, { matchId, which, teamId }) {
    const match = state.matches.find(({ id }) => id === matchId)
    if(which === 0) {
      match.team_one_id = teamId
    } else {
      match.team_two_id = teamId
    }
  },
}

const actions = {
  async [action.GET_MATCHES] ({ commit }) {
    const teams = await api.getMatches()
    commit(mutation.SET_MATCH_LIST, teams)
  },
  async [action.CREATE_MATCH] ({ commit, getters, dispatch }, match) {
    const teamOneMemberIds = match.teamOne.members.map(m => m.id).sort()
    const teamTwoMemberIds = match.teamTwo.members.map(m => m.id).sort()
    const currentTeamOne = getters.teamMap.get(match.teamOne.id)
    const currentTeamTwo = getters.teamMap.get(match.teamTwo.id)
    if(!currentTeamOne || !_.isEqual(teamOneMemberIds, currentTeamOne.members.map(m => m.id).sort())) {
      const reusedTeam = getters.teamByMemberIdsMap.get(teamOneMemberIds.toString())
      if(reusedTeam) {
        match.teamOne.id = reusedTeam.id
      } else {
        const team = await dispatch(action.CREATE_TEAM, {
          name: match.teamOne.name,
          members: match.teamOne.members,
        })
        match.teamOne.id = team.id
      }
    }
    if(!currentTeamTwo || !_.isEqual(teamTwoMemberIds, currentTeamTwo.members.map(m => m.id).sort())) {
      const reusedTeam = getters.teamByMemberIdsMap.get(teamTwoMemberIds.toString())
      if(reusedTeam) {
        match.teamTwo.id = reusedTeam.id
      } else {
        const team = await dispatch(action.CREATE_TEAM, {
          name: match.teamTwo.name,
          members: match.teamTwo.members,
        })
        match.teamTwo.id = team.id
      }
    }
    match = await api.createMatch(rawFriendlyMatch(match))
    commit(mutation.ADD_MATCH, match)
  },
  async [action.UPDATE_MATCH] ({ commit, dispatch, getters }, match) {
    const teamOneMemberIds = match.teamOne.members.map(m => m.id).sort()
    const teamTwoMemberIds = match.teamTwo.members.map(m => m.id).sort()
    const currentMatch = getters.matchMap.get(match.id)
    if(!_.isEqual(teamOneMemberIds, currentMatch.teamOne.members.map(m => m.id).sort())) {
      dispatch(action.UPDATE_MATCH_LINEUP, [match, match.teamOne])
    }
    if(!_.isEqual(teamTwoMemberIds, currentMatch.teamTwo.members.map(m => m.id).sort())) {
      dispatch(action.UPDATE_MATCH_LINEUP, [match, match.teamTwo])
    }
    const rawMatch = rawFriendlyMatch(match)
    rawMatch.team_one_id = undefined
    rawMatch.team_two_id = undefined
    match = await api.updateMatch(rawMatch)
    commit(mutation.SET_MATCH, match)
  },
  async [action.UPDATE_MATCH_LINEUP] ({ commit, getters }, [match, team]) {
    const newTeam = await api.updateMatchLineup(match, rawTeam(team))
    if(!getters.teamMap.has(newTeam.id)) {
      commit(mutation.ADD_TEAM, newTeam)
    }
    commit(mutation.SET_MATCH_TEAM, {
      matchId: match.id,
      which: team.id === match.teamOne.id ? 0 : 1,
      teamId: newTeam.id,
    })
  },
  async [action.DESTROY_MATCH] ({ commit }, { id }) {
    await api.destroyMatch({ id })
    commit(mutation.REMOVE_MATCH, { id })
  },
}

export default { state, getters, mutations, actions }
export { mutations }
