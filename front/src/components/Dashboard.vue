<template>
<div id="dashboard">
  <router-link to="/dashboard/tournaments">Your tournaments</router-link>
  <router-link to="/dashboard/matches">Your matches</router-link>
  <router-link to="/dashboard/teams">Your teams</router-link>
  <router-link to="/teams">Team list</router-link>
  <router-link to="/tournaments">All tournament list</router-link>
  <router-link to="/matches">All match list</router-link>

  <router-view></router-view>
</div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'Dashboard',
  computed: {
    ...mapGetters(['isAdmin', 'activeGames', 'archivizedGames', 'currentUser']),
  },
}
</script>

<style scoped>
</style>
