<template>
<div class="tournaments">
  <h1>Tournaments</h1>
  <ul>
    <li v-for="tournament in filteredTournaments" :key="tournament.id">
      <tournament-overview v-bind="tournament"></tournament-overview>
    </li>
  </ul>

  <h2>Add a tournament</h2>
  <tournament-create>
  </tournament-create>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import TournamentOverview from './TournamentOverview'
import TournamentCreate from './TournamentCreate'

export default {
  name: 'TournamentList',
  props: {
    user: Object,
    game: Object,
  },
  components: {
    TournamentOverview,
    TournamentCreate,
  },
  data () {
    return {
      admin: false,
    }
  },
  computed: {
    filteredTournaments () {
      let list = this.tournamentList
      if(this.user) {
        list = list.filter(tournament =>
          tournament.teams.some(team => team.members.some(m => m.id === this.user.id)) ||
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
}
</script>
