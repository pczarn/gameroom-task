<template>
<div id="dashboard">
  <router-link to="/dashboard/tournaments">Your tournaments</router-link>
  <router-link to="/dashboard/matches">Your matches</router-link>
  <router-link to="/dashboard/teams">Your teams</router-link>
  Your stats
  <router-link to="/teams">Team list</router-link>
  <router-link to="/tournaments">All tournament list</router-link>
  <router-link to="/matches">All match list</router-link>

  <router-view :user="currentUser"></router-view>
</div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'Dashboard',
  computed: {
    ...mapGetters(['currentUser']),
  },
}
</script>

<style scoped>
</style>
