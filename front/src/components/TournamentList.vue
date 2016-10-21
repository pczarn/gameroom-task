<template>
<div class="tournaments">
  <h1>Tournaments</h1>
  <ul>
    <li v-for="tournament in tournamentList" :key="tournament.id">
      <tournament-overview v-bind="tournament"></tournament-overview>
    </li>
  </ul>

  <h2>Add a tournament</h2>
  <tournament-form button-text="Add a tournament"
                   :tournament="newTournament"
                   @submit="add()">
  </tournament-form>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import TournamentOverview from './TournamentOverview'

export default {
  name: 'TournamentList',
  data () {
    return {
      newTournament: {},
      fields: [
        { name: 'title', type: 'text' },
        { name: 'description', type: 'textarea' },
        { name: 'image', type: 'file', accept: "image/*" },
        { name: 'number_of_teams', type: 'number' },
        { name: 'number_of_members_per_team', type: 'num' },
        { name: 'started_at', type: 'datetime' },
      ],
      admin: false,
    }
  },
  components: {
    TournamentOverview,
  },
  computed: {
    ...mapGetters(['tournamentList']),
  },
  methods: {
    async add () {
      await this.$store.dispatch('CREATE_TOURNAMENT', this.newTournament)
      this.newTournament = {}
    },
  },
}
</script>

<style scoped>
</style>
