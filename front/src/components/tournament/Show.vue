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
               :to="{ name: 'tournament rounds', params: { id: tournament.id } }">
    Rounds
  </router-link>
  <span v-else :class="{ bold: showRounds }" class="disabled">Rounds</span>

  <router-link v-if="!showTeams"
               :to="{ name: 'tournament teams', params: { id: tournament.id } }">
    Teams
  </router-link>
  <span v-else :class="{ bold: showTeams }" class="disabled">Teams</span>

  <router-link v-if="canEdit && !showEdit"
               :to="{ name: 'tournament update', params: { id: tournament.id } }">
    Edit
  </router-link>
  <span v-else :class="{ bold: showEdit }" class="disabled">Edit</span>

  <router-link v-if="canDestroy && !showDelete"
               :to="{ name: 'tournament delete', params: { id: tournament.id } }">
    Delete
  </router-link>
  <span v-else :class="{ bold: showDelete }" class="disabled">Delete</span>

  <router-view></router-view>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import policies from 'src/policies'

export default {
  name: 'Tournament',
  computed: {
    canEdit () {
      return policies.tournamentPolicy(this.tournament).update
    },
    canDestroy () {
      return policies.tournamentPolicy(this.tournament).destroy
    },
    playerIds () {
      const teamMemberIds = this.tournament.teams.map(t => t.members.map(m => m.id))
      return new Set([].concat.apply([], teamMemberIds))
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
    ...mapGetters({
      tournament: 'currentTournament',
    }),
  },
}
</script>

<style scoped>
span.disabled {
  color: gray;
}

span.bold {
  font-weight: bold;
  color: black !important;
}
</style>
