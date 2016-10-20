<template>
<div>
  <div v-for="team in teams">
    size {{ team.team_size_limit || 'no limit' }}
    <tournament-team v-bind="team"></tournament-team>
  </div>
</div>
</template>

<script>
import TournamentTeam from './TournamentTeam'

export default {
  props: {
    teams: Array,
    editable: Boolean,
  },
  components: {
    TournamentTeam,
  },
}
</script>

<style scoped>
</style>
