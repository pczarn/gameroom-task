<template>
  <div>
    <div v-for="team_tournament in teams">
      size {{ team_tournament.team_size_limit || 'no limit' }}
      <Team v-bind="team_tournament.team"></Team>
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
