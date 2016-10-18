<template>
<div id="dashboard">
  <router-link to="/games">Game list</router-link>
  <router-link to="/teams">Team list</router-link>
  <router-link to="/matches">All match list</router-link>
  <router-link to="/tournaments">All tournament list</router-link>

  <match-list :for-user="currentUser"></match-list>
  <tournament-list></tournament-list>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import MatchList from './MatchList'
import TournamentList from './TournamentList'

export default {
  name: 'Dashboard',
  data () {
    return {
    }
  },
  components: {
    MatchList,
    TournamentList,
  },
  methods: {
  },
  computed: {
    ...mapGetters(['isAdmin', 'activeGames', 'archivizedGames', 'currentUser']),
  },
}
</script>

<style scoped>
</style>
