import axios from 'axios'
import auth from 'src/auth'
import store from 'src/store'

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
      store.dispatch('SET_ERROR', error.response.data.error)
    }
    return Promise.reject(error)
  })

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
  async updateUser (user) {
    let id = user.id
    let params = {
      name: user.name,
      email: user.email,
      password: user.password,
      password_confirmation: user.password_confirmation,
    }
    return (await axios.patch(`/users/${id}`, { user: params })).data
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
    return (await axios.get('/friendly_matches')).data
  },
  async createMatch (params) {
    return (await axios.post('/friendly_matches', { match: params })).data
  },
  async updateMatch (params) {
    let id = params.id
    params = {
      team_one_id: params.team_one_id,
      team_two_id: params.team_two_id,
      team_one_score: params.team_one_score,
      team_two_score: params.team_two_score,
      game_id: params.game_id,
      played_at: params.played_at,
    }
    return (await axios.patch(`/friendly_matches/${id}`, { match: params })).data
  },
  async updateMatchLineup (match, team) {
    const matchId = match.id
    const lineupId = team.id
    const teamParams = {
      team: { member_ids: team.member_ids },
    }
    return (await axios.patch(`/friendly_matches/${matchId}/lineups/${lineupId}`, teamParams)).data
  },
  destroyMatch (id) {
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
  async updateTournament (params) {
    let id = params.id
    params = {
      title: params.title,
      description: params.description,
      game_id: params.game_id,
      started_at: params.started_at,
      number_of_teams: params.number_of_teams,
      number_of_members_per_team: params.number_of_members_per_team,
    }
    return (await axios.patch(`/tournaments/${id}`, { tournament: params })).data
  },
  destroyTournament (id) {
    return axios.delete(`/tournaments/${id}`)
  },

  async createTournamentLineup (tournament, team) {
    return (await axios.post(`tournaments/${tournament.id}/lineups`, { team: team })).data
  },
  async updateTournamentLineup (tournament, team) {
    let id = team.id
    team = {
      member_ids: team.member_ids,
    }
    return (await axios.patch(`/tournaments/${tournament.id}/lineups/${id}`, { team: team })).data
  },
  destroyTournamentLineup (tournament, team) {
    let id = team.id
    return axios.delete(`/tournaments/${tournament.id}/lineups/${id}`)
  },
  async updateTournamentMatch (tournament, match) {
    const id = match.id
    return (await axios.patch(`/matches/${id}`, { match: match })).data
  },

  createTournamentTeamParticipation (id, team) {
    return axios.post(`/tournaments/${id}/add_team`, { team: team })
  },
  destroyTournamentTeamParticipation (id, team) {
    return axios.post(`/tournaments/${id}/remove_team`, { team: team })
  },
}
