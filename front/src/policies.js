import store from 'src/store'

export default {
  teamPolicy (team) {
    const userId = store.getters.currentUser && store.getters.currentUser.id
    const isAdmin = store.getters.isAdmin
    const isMember = team.members.some(m => m.id === userId)
    return {
      update: isMember || isAdmin,
    }
  },
  friendlyMatchPolicy (match) {
    const userId = store.getters.currentUser && store.getters.currentUser.id
    const isAdmin = store.getters.isAdmin
    if(userId && match) {
      const isOwner = match.owner.id === userId
      const isMember = match.teamOne.members.some(m => m.id === userId) ||
        match.teamTwo.members.some(m => m.id === userId)
      return {
        update: isOwner || isMember || isAdmin,
        destroy: isOwner || isAdmin,
      }
    } else {
      return {}
    }
  },
  tournamentPolicy (tournament) {
    const userId = store.getters.currentUser && store.getters.currentUser.id
    const isAdmin = store.getters.isAdmin
    const isOwner = tournament.owner.id === userId
    const update = (isOwner || isAdmin) && tournament.status !== 'ended'
    const destroy = update && tournament.status === 'open'
    return { update, destroy }
  },
  teamTournamentPolicy (tournament, team) {
    const userId = store.getters.currentUser && store.getters.currentUser.id
    const notFull = !team.numberOfSlots || this.team.members.length < team.numberOfSlots
    const notMember = tournament.teams.every(team => !team.members.some(m => m.id === userId))
    const join = notFull && notMember
    const leave = team.members.map(m => m.id).includes(userId)
    return { join, leave, addMember: notFull }
  },
  tournamentMatchPolicy (tournament, match) {
    const userId = store.getters.currentUser && store.getters.currentUser.id
    const canEditTournament = this.tournamentPolicy(tournament).update
    const isMember = match.teamOne.members.some(m => m.id === userId) ||
        match.teamTwo.members.some(m => m.id === userId)
    const scoreNotSet = typeof match.teamOneScore !== 'number' || typeof match.teamTwoScore !== 'number'
    const update = scoreNotSet && (isMember || canEditTournament)
    return { update }
  },
  gamePolicy (game) {
    const isAdmin = store.getters.isAdmin
    const update = isAdmin
    return { update }
  },
}
