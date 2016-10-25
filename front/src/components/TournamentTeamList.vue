<template>
<div>
  <div v-for="team in tournament.teams">
    size {{ team.team_size_limit || 'no limit' }}
    <tournament-team-overview v-bind="team"></tournament-team-overview>
    <button v-if="canJoin(team)" @click.prevent="join(team)">Join</button>
    <button v-if="canLeave(team)" @click.prevent="leave(team)">Leave</button>
  </div>
</div>
</template>

<script>
import policies from 'src/policies'
import TournamentTeamOverview from './TournamentTeamOverview'

export default {
  props: {
    tournament: Object,
    joinable: Boolean,
  },
  components: {
    TournamentTeamOverview,
  },
  computed: {
    canJoin (team) {
      return policies.teamTournamentPolicy(this.tournament, team).join
    },
    canLeave (team) {
      return policies.teamTournamentPolicy(this.tournament, team).leave
    },
  },
  methods: {
    join (team) {
      team.member_ids.push(this.currentUser.id)
      this.$store.dispatch('UPDATE_TOURNAMENT_LINEUP', [this.tournament, team])
    },
    leave (team) {
      const idx = team.member_ids.findIndex(id => id === this.currentUser.id)
      team.member_ids.splice(idx, 1)
      this.$store.dispatch('UPDATE_TOURNAMENT_LINEUP', [this.tournament, team])
    },
  },
}
</script>

<style scoped>
</style>
