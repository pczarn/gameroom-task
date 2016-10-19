<template>
<div>
  <div v-for="team in teams">
    size {{ team.team_size_limit || 'no limit' }}
    <team v-bind="team"></team>
  </div>
</div>
</template>

<script>
import Team from './Team'

export default {
  props: {
    teams: Array,
    editable: Boolean,
  },
  components: {
    Team,
  },
}
</script>

<style scoped>
</style>
