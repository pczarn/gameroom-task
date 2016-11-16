import { store } from 'src/store'

const IMG_BASE_URL = '//localhost:3000'

export function enrichMatch(match) {
  return {
    id: match.id,
    playedAt: match.played_at,
    createdAt: match.created_at,
    teamOneScore: match.team_one_score,
    teamTwoScore: match.team_two_score,
    teamOne: store.getters.teamMap.get(match.team_one_id),
    teamTwo: store.getters.teamMap.get(match.team_two_id),
    game: store.getters.gameMap.get(match.game_id),
    winner: match.winner_id !== undefined && store.getters.teamMap.get(match.winner_id),
  }
}

export function enrichFriendlyMatch(match) {
  return {
    ...enrichMatch(match),
    owner: store.getters.userMap.get(match.owner_id),
  }
}

export function enrichTournament(tournament) {
  const teams = tournament.teams.map(teamTournament => {
    const team = store.getters.teamMap.get(teamTournament.team_id)
    return {
      id: teamTournament.team_id,
      numberOfSlots: teamTournament.number_of_slots,
      teamTournamentId: teamTournament.id,
      name: team.name,
      members: team.members,
    }
  })
  return {
    id: tournament.id,
    title: tournament.title,
    description: tournament.description,
    numberOfTeams: tournament.number_of_teams,
    numberOfMembersPerTeam: tournament.number_of_members_per_team,
    startedAt: tournament.started_at,
    createdAt: tournament.created_at,
    status: tournament.status,
    imageUrl: IMG_BASE_URL + tournament.image_url,
    owner: store.getters.userMap.get(tournament.owner_id),
    game: store.getters.gameMap.get(tournament.game_id),
    rounds: tournament.rounds.map(matches => matches.map(enrichMatch)),
    teams,
  }
}

export function enrichTeam(team) {
  return {
    id: team.id,
    name: team.name,
    members: team.member_ids.map(memberId => store.getters.userMap.get(memberId)),
    createdAt: team.created_at,
  }
}

export function rawMatch(match) {
  return {
    id: match.id,
    played_at: match.playedAt,
    team_one_score: match.teamOneScore,
    team_two_score: match.teamTwoScore,
  }
}

export function rawFriendlyMatch(match) {
  const basicParams = rawMatch(match)
  return Object.assign(basicParams, {
    team_one_id: match.teamOne.id,
    team_two_id: match.teamTwo.id,
    game_id: match.game.id,
  })
}

export function rawTournamentParams(tournament) {
  return {
    id: tournament.id,
    title: tournament.title,
    description: tournament.description,
    number_of_teams: tournament.numberOfTeams,
    number_of_members_per_team: tournament.numberOfMembersPerTeam,
    started_at: tournament.startedAt,
    game_id: tournament.game.id,
  }
}

export function rawTournament(tournament) {
  return {
    ...rawTournamentParams(tournament),
    status: tournament.status,
    owner_id: tournament.owner.id,
    rounds: tournament.rounds.map(matches => matches.map(rawMatch)),
    teams: tournament.teams.map(team => {
      return {
        id: team.teamTournamentId,
        team_id: team.id,
        number_of_slots: team.numberOfSlots,
      }
    }),
  }
}

export function rawTeam(team) {
  return {
    id: team.id,
    name: team.name,
    member_ids: team.members.map(member => member.id),
  }
}

export function enrichGame(game) {
  return {
    id: game.id,
    name: game.name,
    archivized: game.archivized,
    imageUrl: IMG_BASE_URL + game.image_url,
    imageThumbUrl: IMG_BASE_URL + game.image_thumb_url,
    stats: game.stats.map(({ user_id, mean }) => {
      return {
        user: store.getters.userMap.get(user_id),
        value: mean,
      }
    }),
  }
}
