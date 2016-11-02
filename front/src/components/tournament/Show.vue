<template>
<div class="tournament" v-if="tournament">
  <a href="#" @click="$router.go(-1)">Go back</a>

  <h2>Tournament {{ tournament.title }}</h2>

  <p>{{ tournament.description }}</p>

  Owner {{ tournament.owner.name }}<br>
  <span v-if="tournament.startedAt">
    Starts at <time :datetime="tournament.startedAt">{{ tournament.startedAt }}</time>
  </span>
  <span v-else>
    Starts at an unknown time
  </span>

  status: {{ tournament.status }}

  <br>

  <router-link v-if="hasRounds && !showRounds"
               :to="{ name: 'tournament rounds', params: { id } }">
    Rounds
  </router-link>
  <span v-else :class="{ bold: showRounds }">Rounds</span>

  <router-link v-if="!showTeams"
               :to="{ name: 'tournament teams', params: { id } }">
    Teams
  </router-link>
  <span v-else :class="{ bold: showTeams }">Teams</span>

  <router-link v-if="canEdit && !showEdit"
               :to="{ name: 'tournament update', params: { id } }">
    Edit
  </router-link>
  <span v-else :class="{ bold: showEdit }">Edit</span>

  <router-link v-if="canDestroy && !showDelete"
               :to="{ name: 'tournament delete', params: { id } }">
    Delete
  </router-link>
  <span v-else :class="{ bold: showDelete }">Delete</span>

  <router-view :tournament="tournament"></router-view>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import policies from 'src/policies'
import TournamentTeamList from './TeamList'
import TournamentForm from './Form'
import Round from './Round'

export default {
  name: 'Tournament',
  components: {
    TournamentTeamList,
    TournamentForm,
    Round,
  },
  data () {
    return {
      newTournament: {
        teams: [],
      },
    }
  },
  computed: {
    canEdit () {
      return policies.tournamentPolicy(this.tournament).update
    },
    canDestroy () {
      return policies.tournamentPolicy(this.tournament).destroy
    },
    id () {
      return parseInt(this.$route.params.id)
    },
    playerIds () {
      const teamMemberIds = this.tournament.teams.map(t => t.members.map(m => m.id))
      return new Set([].concat.apply([], teamMemberIds))
    },
    tournament () {
      return this.tournamentMap.get(this.id)
    },
    showRounds () {
      return this.$route.name === 'tournament rounds' || (
        this.$route.name === 'tournament' && this.hasRounds
      )
    },
    showTeams () {
      return this.$route.name === 'tournament teams' || (
        this.$route.name === 'tournament' && !this.hasRounds
      )
    },
    showEdit () {
      return this.$route.name === 'tournament update'
    },
    showDelete () {
      return this.$route.name === 'tournament delete'
    },
    hasRounds () {
      return this.tournament.rounds.length > 0
    },
    ...mapGetters(['tournamentMap', 'currentUser', 'isAdmin', 'userList']),
  },
}
</script>

<style scoped>
span.bold {
  font-weight: bold;
}
</style>
