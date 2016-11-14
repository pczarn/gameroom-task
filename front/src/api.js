import axios from 'axios'
import _ from 'lodash'
import auth from 'src/auth'
import store from 'src/store'
import * as action from 'src/store/action_types'

const API_URL = 'http://localhost:3000/api/v1/'
const TOKEN_TYPE = 'Bearer '

axios.defaults.baseURL = API_URL

// Add a response interceptor
axios.interceptors.response.use(
  response => response,
  error => {
    if(error.response.status === 401) {
      if(auth.getToken()) {
        auth.logOut()
      }
    } else if(error.response.status === 422) {
      store.dispatch(action.SET_ERROR, error.response.data.error)
    }
    return Promise.reject(error)
  })

export default {
  async getUserWithToken (creds) {
    const { data: { knock: { jwt }, user } } = await axios.post('/user_token', { auth: creds })
    return { user, token: jwt }
  },
  logIn (token) {
    axios.defaults.headers.common['Authorization'] = TOKEN_TYPE + token
  },
  logOut () {
    axios.defaults.headers.common['Authorization'] = ''
  },

  async getUsers () {
    return (await axios.get('/users')).data
  },
  async createUser (user) {
    return (await axios.post('/users', { user })).data
  },
  async updateUser (userParams) {
    const id = user.id
    const user = _.pick(userParams, [
      'name',
      'email',
      'password',
      'password_confirmation',
    ])
    return (await axios.patch(`/users/${id}`, { user })).data
  },

  async getGames () {
    return (await axios.get('/games')).data
  },
  async createGame (game) {
    return (await axios.post('/games', { game })).data
  },
  async updateGame (game) {
    const id = game.id
    return (await axios.patch(`/games/${id}`, { game })).data
  },
  destroyGame ({ id }) {
    return axios.delete(`/games/${id}`)
  },

  async getTeams () {
    return (await axios.get('/teams')).data
  },
  async createTeam (team) {
    return (await axios.post('/teams', { team })).data
  },
  async updateTeam (teamParams) {
    const id = teamParams.id
    const team = { name: teamParams.name }
    return (await axios.patch(`/teams/${id}`, { team })).data
  },
  destroyTeam ({ id }) {
    return axios.delete(`/teams/${id}`)
  },

  async getFriendlyMatches () {
    return (await axios.get('/friendly_matches')).data
  },
  async createFriendlyMatch (match) {
    return (await axios.post('/friendly_matches', { match })).data
  },
  async updateFriendlyMatch (matchParams) {
    const id = matchParams.id
    const match = _.pick(matchParams, [
      'team_one_id',
      'team_two_id',
      'team_one_score',
      'team_two_score',
      'game_id',
      'played_at',
    ])
    return (await axios.patch(`/friendly_matches/${id}`, { match })).data
  },
  async updateFriendlyMatchLineup (match, teamParams) {
    const id = teamParams.id
    const team = _.pick(teamParams, ['name', 'member_ids'])
    return (await axios.patch(`/friendly_matches/${match.id}/lineups/${id}`, { team })).data
  },
  destroyFriendlyMatch ({ id }) {
    return axios.delete(`/friendly_matches/${id}`)
  },

  async getTournaments () {
    return (await axios.get('/tournaments')).data
  },
  async getTournament (tournament) {
    const id = tournament.id
    return (await axios.get(`/tournaments/${id}`)).data
  },
  async createTournament (params) {
    return (await axios.post('/tournaments', { tournament: params })).data
  },
  async updateTournament (tournamentParams) {
    const id = tournamentParams.id
    const tournament = _.pick(tournamentParams, [
      'title',
      'description',
      'game_id',
      'started_at',
      'number_of_teams',
      'number_of_members_per_team',
    ])
    return (await axios.patch(`/tournaments/${id}`, { tournament })).data
  },
  destroyTournament ({ id }) {
    return axios.delete(`/tournaments/${id}`)
  },

  async createTournamentLineup (tournament, team) {
    if(team.id !== undefined) {
      return (await axios.post(`tournaments/${tournament.id}/lineups`, { id: team.id })).data
    } else {
      return (await axios.post(`tournaments/${tournament.id}/lineups`, { team })).data
    }
  },
  async updateTournamentLineup (tournament, teamParams) {
    const id = teamParams.id
    const team = _.pick(teamParams, ['name', 'member_ids'])
    return (await axios.patch(`/tournaments/${tournament.id}/lineups/${id}`, { team })).data
  },
  destroyTournamentLineup (tournament, team) {
    const id = team.id
    return axios.delete(`/tournaments/${tournament.id}/lineups/${id}`)
  },
  async updateTournamentMatch (tournament, match) {
    const id = match.id
    return (await axios.patch(`/matches/${id}`, { match })).data
  },
}
