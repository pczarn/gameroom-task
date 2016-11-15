import Vue from 'vue'
import axios from 'axios'
import api from 'src/api'
import _ from 'lodash'

import {
  ADD_TEAM,
  ADD_TEAM_TO_TOURNAMENT,
  REMOVE_TEAM_FROM_TOURNAMENT,
  SET_TOURNAMENT_TEAM,
  SET_TOURNAMENT,
  SET_TOURNAMENT_MATCH,
  REMOVE_TOURNAMENT,
  ADD_TOURNAMENT,
  SET_TOURNAMENT_LIST,

} from './mutation_types'

import {
  GET_TOURNAMENTS,
  CREATE_TOURNAMENT,
  UPDATE_TOURNAMENT,
  DESTROY_TOURNAMENT,
  UPDATE_TOURNAMENT_MATCH,
  UPDATE_TOURNAMENT_LINEUP_LIST,
  CREATE_TOURNAMENT_LINEUP,
  UPDATE_TOURNAMENT_LINEUP,
  DESTROY_TOURNAMENT_LINEUP,
} from './action_types'

import {
  enrichTournament,
  rawTournamentParams,
  rawTeam,
  rawTournament,
  rawMatch,
} from 'src/store/mapping'

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

  [ADD_TEAM_TO_TOURNAMENT] (state, { tournamentId, team }) {
    const tournament = state.tournaments.find(({ id }) => id === tournamentId)
    tournament.teams.push({
      team_id: team.id,
      number_of_slots: null,
    })
  },

  [REMOVE_TEAM_FROM_TOURNAMENT] (state, { tournamentId, team }) {
    const tournament = state.tournaments.find(({ id }) => id === tournamentId)
    const teamIndex = tournament.teams.findIndex(({ id }) => id === team.id)
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
  async [GET_TOURNAMENTS] ({ commit }) {
    const tournaments = await api.getTournaments()
    commit(SET_TOURNAMENT_LIST, tournaments)
  },

  // Creates a tournament, with teams
  async [CREATE_TOURNAMENT] ({ commit, dispatch }, tournament) {
    tournament = await api.createTournament(rawTournamentParams(tournament))
    for(const team of tournament.teams) {
      dispatch(CREATE_TOURNAMENT_LINEUP, [tournament, team])
    }
    commit(ADD_TOURNAMENT, tournament)
    dispatch(action.CLEAR_ERRORS)
  },

  // Updates a tournament, with teams that can be added, updated or removed.
  async [UPDATE_TOURNAMENT] ({ commit, dispatch }, tournament) {
    await dispatch(UPDATE_TOURNAMENT_LINEUP_LIST, tournament)
    // watch out for the order of requests. Updating must happen last.
    const updatedTournament = await api.updateTournament(rawTournamentParams(tournament))
    commit(SET_TOURNAMENT, updatedTournament)
    dispatch(action.CLEAR_ERRORS)
  },

  async [DESTROY_TOURNAMENT] ({ commit }, { id }) {
    await api.destroyTournament({ id })
    commit(REMOVE_TOURNAMENT, { id })
  },

  // For match

  async [UPDATE_TOURNAMENT_MATCH] ({ commit, getters }, [tournament, match]) {
    const newMatch = await api.updateTournamentMatch(tournament, rawMatch(match))
    commit(SET_TOURNAMENT_MATCH, { tournament, match: newMatch })
    const rawTournament = await api.getTournament(tournament)
    commit(SET_TOURNAMENT, rawTournament)
  },

  // For all lineups

  async [UPDATE_TOURNAMENT_LINEUP_LIST] ({ commit, dispatch, getters }, tournament) {
    const prevTournament = getters.tournamentMap.get(tournament.id)
    const prevTeams = prevTournament.teams
    const newTeams = tournament.teams
    const prevTeamIds = new Set(prevTeams.map(t => t.id))
    const newTeamIds = new Set(newTeams.map(t => t.id))
    // Finds which teams need to be added, removed or updated.
    const createTeams = [...newTeams].filter(team => !prevTeamIds.has(team.id))
    const destroyTeams = [...prevTeams].filter(team => !newTeamIds.has(team.id))
    const teamsIntersection = [...newTeams].filter(team => prevTeamIds.has(team.id))
    let promises = []
    for(const team of createTeams) {
      promises.push(dispatch(CREATE_TOURNAMENT_LINEUP, [tournament, team]))
    }
    for(const team of destroyTeams) {
      promises.push(dispatch(DESTROY_TOURNAMENT_LINEUP, [tournament, team]))
    }
    for(const team of teamsIntersection) {
      promises.push(dispatch(UPDATE_TOURNAMENT_LINEUP, [tournament, team]))
    }
    await axios.all(promises)
  },

  // For individual lineups

  async [CREATE_TOURNAMENT_LINEUP] ({ commit, getters }, [tournament, team]) {
    const newTeam = await api.createTournamentLineup(tournament, rawTeam(team))
    if(!getters.teamMap.has(newTeam.id)) {
      // The team is new.
      commit(ADD_TEAM, newTeam)
    }
    // If the team is not new, it's reused. A reused team is not changed.
    commit(ADD_TEAM_TO_TOURNAMENT, { tournamentId: tournament.id, team: newTeam })
  },

  async [UPDATE_TOURNAMENT_LINEUP] ({ commit, getters }, [tournament, team]) {
    const prevMemberIds = getters.teamMap.get(team.id).members.map(m => m.id)
    const newMemberIds = team.members.map(m => m.id)
    if(!_.isEqual(prevMemberIds.sort(), newMemberIds.sort())) {
      console.log(team, rawTeam(team))
      const newTeam = await api.updateTournamentLineup(tournament, rawTeam(team))
      if(!getters.teamMap.has(newTeam.id)) {
        // The team is new.
        commit(ADD_TEAM, newTeam)
      }
      // If the team is not new, it's reused. A reused team is not changed.
      commit(SET_TOURNAMENT_TEAM, { tournamentId: tournament.id, fromTeam: team, toTeam: newTeam })
    }
  },

  async [DESTROY_TOURNAMENT_LINEUP] ({ commit, getters }, [tournament, team]) {
    await api.destroyTournamentLineup(tournament, rawTeam(team))
    commit(REMOVE_TEAM_FROM_TOURNAMENT, { tournamentId: tournament.id, team: team })
  },
}

export default { state, getters, mutations, actions }
export { mutations }
