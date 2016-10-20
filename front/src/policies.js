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
    return {
      update: userId && match && (
        match.owner.id === userId ||
        match.teamOne.member_ids.includes(userId) ||
        match.teamTwo.member_ids.includes(userId) ||
        isAdmin
      ),
    }
  }
}
