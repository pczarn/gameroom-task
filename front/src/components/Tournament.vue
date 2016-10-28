<template>
<div class="tournament" v-if="rawTournament">
  <a href="#" @click="$router.go(-1)">Go back</a>

  <h2>Tournament {{ tournament.title }}</h2>
  Owner {{ tournament.owner.name }}<br>
  <span v-if="tournament.startedAt">
    Starts at <time :datetime="tournament.startedAt">{{ tournament.startedAt }}</time>
  </span>
  <span v-else>
    Starts at an unknown time
  </span>

  status: {{ tournament.status }}

  <br>

  <router-link v-if="hasRounds && !showRounds" :to="{ name: 'tournament rounds', params: { id } }">Rounds</router-link>
  <span v-else :class="{ bold: showRounds }">Rounds</span>

  <router-link v-if="!showTeams" :to="{ name: 'tournament teams', params: { id } }">Teams</router-link>
  <span v-else :class="{ bold: showTeams }">Teams</span>

  <router-link v-if="canEdit && !showEdit" :to="{ name: 'tournament update', params: { id } }">Edit</router-link>
  <span v-else :class="{ bold: showEdit }">Edit</span>

  <router-link v-if="canDestroy && !showDelete" :to="{ name: 'tournament delete', params: { id } }">Delete</router-link>
  <span v-else :class="{ bold: showDelete }">Delete</span>

  <div v-show="showTeams">
    <h3>Teams</h3>
    <tournament-team-list :tournament="tournament" :editable="canEdit">
    </tournament-team-list>
  </div>

  <div v-show="showRounds">
    <h3>Rounds</h3>
    <round v-for="(round, index) in tournament.rounds" :matches="round" :number="index" :tournament="tournament">
    </round>
  </div>

  <div v-show="showEdit" v-if="canEdit">
    Edit tournament
    <tournament-form button-text="Update tournament"
                     :value="tournament"
                     @submit="update">
    </tournament-form>
  </div>

  <div v-show="showDelete" v-if="canDestroy">
    Delete the tournament.
    <button v-if="canDestroy" @click="destroy()">Delete</button>
  </div>
</div>
</template>

<script>
import Vue from 'vue'
import axios from 'axios'
import { mapGetters, mapActions } from 'vuex'
import policies from 'src/policies'
import TournamentTeamList from './TournamentTeamList'
import TournamentForm from './TournamentForm'
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
    rawTournament () {
      return this.tournamentMap.get(this.id)
    },
    playerIds () {
      const teamMemberIds = this.rawTournament.teams.map(t => t.members.map(m => m.id))
      return new Set([].concat.apply([], teamMemberIds))
    },
    tournament () {
      this.rawTournament.potentialPlayers = this.userList.filter(user => !this.playerIds.has(user.id))
      this.rawTournament.policy = policies.tournamentPolicy(this.rawTournament)
      return this.rawTournament
    },
    showRounds () {
      return this.$route.name === 'tournament rounds' || (
        this.$route.name == 'tournament' && this.hasRounds
      )
    },
    showTeams () {
      return this.$route.name === 'tournament teams' || (
        this.$route.name == 'tournament' && !this.hasRounds
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
  methods: {
    async update (newTournament) {
      const newTeams = newTournament.teams.filter(team => team.id === undefined)
      const promises = newTeams.map(team => this.$store.dispatch('CREATE_TEAM'))
      const createdTeams = await axios.all(promises)
      for(const team of createdTeams) {
        this.tournament.teams.push(team)
        newTournament.teams.push(team)
      }
      this.updateTournament(newTournament)
    },
    destroy () {
      this.destroyTournament(this.tournament)
      this.$router.go(-1)
    },
    ...mapActions({
      updateTournament: 'UPDATE_TOURNAMENT',
      destroyTournament: 'DESTROY_TOURNAMENT',
    }),
  },
}
</script>

<style scoped>
span.bold {
  font-weight: bold;
}
</style>
