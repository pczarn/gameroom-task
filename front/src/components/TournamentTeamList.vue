<template>
<div>
  <div v-for="(team, idx) in tournament.teams">
    size {{ team.team_size_limit || 'no limit' }}
    <tournament-team-overview v-bind="team"></tournament-team-overview>
    <button v-if="canJoin[idx]" @click.prevent="join(team)">Join</button>
    <button v-if="canLeave[idx]" @click.prevent="leave(team)">Leave</button>
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
    canJoin () {
      return this.tournament.teams.map(team => {
        return policies.teamTournamentPolicy(this.tournament, team).join
      })
    },
    canLeave () {
      return this.tournament.teams.map(team => {
        return policies.teamTournamentPolicy(this.tournament, team).leave
      })
    },
  },
  methods: {
    join (team) {
      team.members.push(this.currentUser)
      this.$store.dispatch('UPDATE_TOURNAMENT_LINEUP', [this.tournament, team])
    },
    leave (team) {
      const idx = team.members.findIndex(m => m.id === this.currentUser.id)
      team.members.splice(idx, 1)
      this.$store.dispatch('UPDATE_TOURNAMENT_LINEUP', [this.tournament, team])
    },
  },
}
</script>

<style scoped>
</style>
