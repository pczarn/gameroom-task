import store from 'src/store'

export default {
  teamPolicy (team) {
    let userId = store.getters.currentUser && store.getters.currentUser.id
    let isAdmin = store.getters.isAdmin
    const isMember = team.members.some(m => m.id === userId)
    return {
      update: isMember || isAdmin,
    }
  },
  friendlyMatchPolicy (match) {
    let userId = store.getters.currentUser && store.getters.currentUser.id
    let isAdmin = store.getters.isAdmin
    if(userId && match) {
      let isOwner = match.owner.id === userId
      let isMember = match.teamOne.members.some(m => m.id === userId) ||
        match.teamTwo.members.some(m => m.id === userId)
      return {
        update: isOwner || isMember || isAdmin,
        destroy: isMember || isAdmin,
      }
    } else {
      return {}
    }
  },
  tournamentPolicy (tournament) {
    let userId = store.getters.currentUser && store.getters.currentUser.id
    let isAdmin = store.getters.isAdmin
    const isOwner = tournament.owner.id === userId
    const update = (isOwner || isAdmin) && tournament.status !== 'ended'
    const destroy = update && tournament.status === 'open'
    return { update, destroy }
  },
  teamTournamentPolicy (tournament, team) {
    let userId = store.getters.currentUser && store.getters.currentUser.id
    const notFull = !team.team_size_limit || this.team.members.length < team.team_size_limit
    const notMember = tournament.teams.every(team => !team.members.some(m => m.id === userId))
    const join = notFull && notMember
    const leave = team.members.map(m => m.id).includes(userId)
    return { join, leave }
  },
}
