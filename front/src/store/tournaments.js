import Vue from 'vue'
import axios from 'axios'
import api from 'src/api'
import _ from 'lodash'

import {
  SET_TOURNAMENT_LIST,
  ADD_TOURNAMENT,
  SET_TOURNAMENT,
  REMOVE_TOURNAMENT,
  ADD_TEAM_TO_TOURNAMENT,
  REMOVE_TEAM_FROM_TOURNAMENT,
  SET_TOURNAMENT_TEAM,
  SET_TOURNAMENT_MATCH,
} from './mutation_types'
import { enrichTournament, rawTournamentParams, rawTeam, rawTournament, rawMatch } from 'src/store/mapping'

const state = {
  tournaments: [],
}

const getters = {
  rawTournamentList (state) {
    return state.tournaments
  },
  tournamentList (state, getters) {
    return getters.rawTournamentList.map(enrichTournament)
  },
  tournamentMap (state, getters) {
    return new Map(getters.tournamentList.map(tournament => [tournament.id, tournament]))
  },
}

const mutations = {
  [SET_TOURNAMENT_LIST] (state, tournaments) {
    state.tournaments = tournaments
  },

  [ADD_TOURNAMENT] (state, tournament) {
    state.tournaments.push(tournament)
  },

  [SET_TOURNAMENT] (state, tournament) {
    const idx = state.tournaments.findIndex(({ id }) => id === tournament.id)
    state.tournaments.splice(idx, 1, tournament)
  },

  [REMOVE_TOURNAMENT] (state, tournament) {
    const idx = state.tournaments.findIndex(({ id }) => id === tournament.id)
    state.tournaments.splice(idx, 1)
  },

  [ADD_TEAM_TO_TOURNAMENT] (state, { tournamentId, teamId }) {
    const tournament = state.tournaments.find(({ id }) => id === tournamentId)
    const team = state.teams.find(({ id }) => id === teamId)
    tournament.teams.push(team)
  },

  [REMOVE_TEAM_FROM_TOURNAMENT] (state, { tournamentId, teamId }) {
    const tournament = state.tournaments.find(({ id }) => id === tournamentId)
    const teamIndex = tournament.teams.findIndex(({ id }) => id === teamId)
    tournament.teams.splice(teamIndex, 1)
  },

  [SET_TOURNAMENT_TEAM] (state, { tournamentId, fromTeam, toTeam }) {
    const tournament = state.tournaments.find(({ id }) => id === tournamentId)
    const teamIndex = tournament.teams.findIndex(team => team.team_id === fromTeam.id)
    Vue.set(tournament.teams[teamIndex], 'team_id', toTeam.id)
  },

  [SET_TOURNAMENT_MATCH] (state, { tournament, match }) {
    tournament = state.tournaments.find(({ id }) => id === tournament.id)
    for(const round of tournament.rounds) {
      const idx = round.findIndex(m => m.id === match.id)
      if(idx !== -1) {
        Vue.set(round, idx, match)
        break
      }
    }
  },
}

const actions = {
  async GET_TOURNAMENTS ({ commit }) {
    const tournaments = await api.getTournaments()
    commit('SET_TOURNAMENT_LIST', tournaments)
  },
  async CREATE_TOURNAMENT ({ commit }, tournament) {
    tournament = await api.createTournament(rawTournamentParams(tournament))
    commit('ADD_TOURNAMENT', tournament)
  },
  async UPDATE_TOURNAMENT ({ commit, dispatch, getters }, tournament) {
    const prevTournament = getters.tournamentMap.get(tournament.id)
    const prevTeams = prevTournament.teams
    const newTeams = tournament.teams
    const prevTeamIds = new Set(prevTeams.map(t => t.id))
    const newTeamIds = new Set(newTeams.map(t => t.id))
    const createTeams = [...newTeams].filter(team => !prevTeamIds.has(team.id))
    const destroyTeams = [...prevTeams].filter(team => !newTeamIds.has(team.id))
    const teamsIntersection = [...newTeams].filter(team => prevTeamIds.has(team.id))
    let promises = []
    for(const team of createTeams) {
      promises.push(api.createTournamentLineup(tournament, rawTeam(team)))
    }
    for(const team of destroyTeams) {
      promises.push(api.destroyTournamentLineup(tournament, rawTeam(team)))
    }
    for(const team of teamsIntersection) {
      const prevMemberIds = getters.teamMap.get(team.id).members.map(m => m.id)
      const newMemberIds = team.members.map(m => m.id)
      if(!_.isEqual(prevMemberIds.sort(), newMemberIds.sort())) {
        promises.push(api.updateTournamentLineup(tournament, rawTeam(team)))
      }
    }
    const updatePromise = api.updateTournament(rawTournamentParams(tournament))
    promises = [updatePromise, ...promises]
    await axios.all(promises)
    // do not use the response of updateTournament, because we don't know the order in which
    // the requests will be processed.
    commit('SET_TOURNAMENT', rawTournament(tournament))
  },
  async DESTROY_TOURNAMENT ({ commit }, { id }) {
    await api.destroyTournament(id)
    commit('REMOVE_TOURNAMENT', { id: id })
  },
  async UPDATE_TOURNAMENT_LINEUP ({ commit, getters }, [tournament, team]) {
    const newTeam = await api.updateTournamentLineup(tournament, rawTeam(team))
    if(!getters.teamMap.has(newTeam.id)) {
      commit('ADD_TEAM', newTeam)
    } else {
      commit('SET_TEAM', newTeam)
    }
    commit('SET_TOURNAMENT_TEAM', { tournamentId: tournament.id, fromTeam: team, toTeam: newTeam })
  },
  async UPDATE_TOURNAMENT_MATCH ({ commit, getters }, [tournament, match]) {
    const newMatch = await api.updateTournamentMatch(tournament, rawMatch(match))
    commit('SET_TOURNAMENT_MATCH', { tournament, match: newMatch })
    const rawTournament = await api.getTournament(tournament)
    commit('SET_TOURNAMENT', rawTournament)
  },
}

export default { state, getters, mutations, actions }
export { mutations }
