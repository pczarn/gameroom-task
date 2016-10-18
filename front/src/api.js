import axios from 'axios'
import {store} from './main'

const API_URL = 'http://localhost:3000/api/v1/'
const TOKEN_TYPE = 'Bearer '

axios.defaults.baseURL = API_URL

export default {
  async getUserWithToken (creds) {
    let jwt, user
    ({ data: { knock: { jwt }, user } } = await axios.post('/user_token', { auth: creds }))
    return { user: user, token: jwt }
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

  async getGames () {
    return (await axios.get('/games')).data
  },
  async createGame (params) {
    return (await axios.post('/games', { game: params })).data
  },
  async updateGame (params) {
    let id = params.id
    return (await axios.patch(`/games/${id}`, { game: params })).data
  },
  destroyGame (id) {
    return axios.delete(`/games/${id}`)
  },

  async getTeams () {
    return (await axios.get('/teams')).data
  },
  async createTeam (params) {
    return (await axios.post('/teams', { team: params })).data
  },
  async updateTeam (params) {
    let id = params.id
    return (await axios.patch(`/teams/${id}`, { team: params })).data
  },
  destroyTeam (id) {
    return axios.delete(`/teams/${id}`)
  },

  async getMatches () {
    return (await axios.get('/matches')).data
  },
  async createMatch (params) {
    return (await axios.post('/matches', { match: params })).data
  },
  async updateMatch (params) {
    let id = params.id
    return (await axios.patch(`/matches/${id}`, { match: params })).data
  },
  destroyMatch (id) {
    return axios.delete(`/matches/${id}`)
  },

  async getTournaments () {
    return (await axios.get('/tournaments')).data
  },
  async createTournament (params) {
    return (await axios.post('/tournaments', { tournament: params })).data
  },
  async updateTournament (params) {
    let id = params.id
    return (await axios.patch(`/tournaments/${id}`, { tournament: params })).data
  },
  destroyTournament (id) {
    return axios.delete(`/tournaments/${id}`)
  },

  createTournamentTeamParticipation (id, team) {
    return axios.post(`/tournaments/${id}/add_team`, { team: team })
  },
  destroyTournamentTeamParticipation (id, team) {
    return axios.post(`/tournaments/${id}/remove_team`, { team: team })
  },
}
