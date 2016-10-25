import { store } from 'src/main'

export default {
  teamPolicy (team) {
    let userId = store.getters.currentUser && store.getters.currentUser.id
    let isAdmin = store.getters.isAdmin
    return {
      update: team.member_ids.includes(userId) || isAdmin,
    }
  },
  friendlyMatchPolicy (match) {
    let userId = store.getters.currentUser && store.getters.currentUser.id
    let isAdmin = store.getters.isAdmin
    if(userId && match) {
      let isOwner = match.owner.id === userId
      let isMember = match.teamOne.member_ids.includes(userId) ||
        match.teamTwo.member_ids.includes(userId)
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
}
