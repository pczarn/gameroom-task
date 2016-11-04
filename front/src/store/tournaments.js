import Vue from 'vue'
import axios from 'axios'
import api from 'src/api'
import _ from 'lodash'

import * as mutation from './mutation_types'
import * as action from './action_types'
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
  [mutation.SET_TOURNAMENT_LIST] (state, tournaments) {
    state.tournaments = tournaments
  },

  [mutation.ADD_TOURNAMENT] (state, tournament) {
    state.tournaments.push(tournament)
  },

  [mutation.SET_TOURNAMENT] (state, tournament) {
    const idx = state.tournaments.findIndex(({ id }) => id === tournament.id)
    state.tournaments.splice(idx, 1, tournament)
  },

  [mutation.REMOVE_TOURNAMENT] (state, tournament) {
    const idx = state.tournaments.findIndex(({ id }) => id === tournament.id)
    state.tournaments.splice(idx, 1)
  },

  [mutation.ADD_TEAM_TO_TOURNAMENT] (state, { tournamentId, teamId }) {
    const tournament = state.tournaments.find(({ id }) => id === tournamentId)
    const team = state.teams.find(({ id }) => id === teamId)
    tournament.teams.push(team)
  },

  [mutation.REMOVE_TEAM_FROM_TOURNAMENT] (state, { tournamentId, teamId }) {
    const tournament = state.tournaments.find(({ id }) => id === tournamentId)
    const teamIndex = tournament.teams.findIndex(({ id }) => id === teamId)
    tournament.teams.splice(teamIndex, 1)
  },

  [mutation.SET_TOURNAMENT_TEAM] (state, { tournamentId, fromTeam, toTeam }) {
    const tournament = state.tournaments.find(({ id }) => id === tournamentId)
    const teamIndex = tournament.teams.findIndex(team => team.team_id === fromTeam.id)
    Vue.set(tournament.teams[teamIndex], 'team_id', toTeam.id)
  },

  [mutation.SET_TOURNAMENT_MATCH] (state, { tournament, match }) {
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
  async [action.GET_TOURNAMENTS] ({ commit }) {
    const tournaments = await api.getTournaments()
    commit(mutation.SET_TOURNAMENT_LIST, tournaments)
  },
  async [action.CREATE_TOURNAMENT] ({ commit }, tournament) {
    tournament = await api.createTournament(rawTournamentParams(tournament))
    commit(mutation.ADD_TOURNAMENT, tournament)
  },
  async [action.UPDATE_TOURNAMENT] ({ commit, dispatch, getters }, tournament) {
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
    commit(mutation.SET_TOURNAMENT, rawTournament(tournament))
  },
  async [action.DESTROY_TOURNAMENT] ({ commit }, { id }) {
    await api.destroyTournament(id)
    commit(mutation.REMOVE_TOURNAMENT, { id: id })
  },
  async [action.UPDATE_TOURNAMENT_LINEUP] ({ commit, getters }, [tournament, team]) {
    const newTeam = await api.updateTournamentLineup(tournament, rawTeam(team))
    if(!getters.teamMap.has(newTeam.id)) {
      commit(mutation.ADD_TEAM, newTeam)
    } else {
      commit(mutation.SET_TEAM, newTeam)
    }
    commit(mutation.SET_TOURNAMENT_TEAM, { tournamentId: tournament.id, fromTeam: team, toTeam: newTeam })
  },
  async [action.UPDATE_TOURNAMENT_MATCH] ({ commit, getters }, [tournament, match]) {
    const newMatch = await api.updateTournamentMatch(tournament, rawMatch(match))
    commit(mutation.SET_TOURNAMENT_MATCH, { tournament, match: newMatch })
    const rawTournament = await api.getTournament(tournament)
    commit(mutation.SET_TOURNAMENT, rawTournament)
  },
}

export default { state, getters, mutations, actions }
export { mutations }
