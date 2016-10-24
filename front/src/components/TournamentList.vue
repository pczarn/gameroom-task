<template>
<div class="tournaments">
  <h1>Tournaments</h1>
  <ul>
    <li v-for="tournament in filteredTournaments" :key="tournament.id">
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
import TournamentForm from './TournamentForm'

export default {
  name: 'TournamentList',
  props: {
    user: Object,
    game: Object,
  },
  data () {
    return {
      newTournament: {
        teams: [],
      },
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
    TournamentForm,
  },
  computed: {
    filteredTournaments () {
      let list = this.tournamentList
      console.log(list)
      if(this.user) {
        list = list.filter(tournament =>
          tournament.teams.some(team => team.member_ids.includes(this.user.id)) ||
          tournament.owner.id === this.user.id
        )
      }
      if(this.game) {
        list = list.filter(tournament => tournament.game.id === this.game.id)
      }
      return list
    },
    ...mapGetters(['tournamentList']),
  },
  methods: {
    async add () {
      await this.$store.dispatch('CREATE_TOURNAMENT', this.newTournament)
      this.newTournament = { teams: [] }
    },
  },
}
</script>

<style scoped>
</style>
