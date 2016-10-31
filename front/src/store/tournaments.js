import Vue from 'vue'

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
import { enrichTournament } from 'src/store/mapping'

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

export default { state, getters, mutations }
export { mutations }
