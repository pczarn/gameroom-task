<template>
<div class="tournament">
  <a href="#" @click="$router.go(-1)">Go back</a>

  <h2>Tournament {{ tournament.title }}</h2>
  <span v-if="tournament.started_at">
    Starts at <time :datetime="tournament.started_at">{{ tournament.started_at }}</time>
  </span>
  <span v-else>
    Starts at an unknown time
  </span>

  status: {{ tournament.status }}

  <br>

  <h3 v-if="tournament.teams.length > 0">Teams</h3>
  <tournament-team-list :teams="tournament.teams" :editable="true"></tournament-team-list>
  <button v-if="editable" @click="remove()">Remove</button>

  <h3 v-if="tournament.rounds.length > 0">Rounds</h3>
  <round v-for="(round, index) in tournament.rounds" :matches="round" :number="index"></round>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import TournamentTeamList from './TournamentTeamList'
import Round from './Round'

export default {
  name: 'Tournament',
  components: {
    TournamentTeamList,
    Round,
  },
  computed: {
    editable () {
      return this.tournament.editable
    },
    id () {
      return parseInt(this.$route.params.id)
    },
    tournament () {
      return this.tournamentMap.get(this.id)
    },
    ...mapGetters(['tournamentMap']),
  },
}
</script>

<style scoped>
</style>
