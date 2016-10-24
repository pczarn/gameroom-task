<template>
<div class="tournament" v-if="tournament">
  <a href="#" @click="$router.go(-1)">Go back</a>

  <h2>Tournament {{ tournament.title }}</h2>
  Owner {{ tournament.owner.name }}<br>
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

  <div v-if="editable">
    Edit tournament
    <tournament-form button-text="Update tournament"
                     :value="tournament"
                     @submit="update">
    </tournament-form>
  </div>
</div>
</template>

<script>
import Vue from 'vue'
import axios from 'axios'
import { mapGetters, mapActions } from 'vuex'
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
    editable () {
      // return this.tournament.editable
      return this.tournament.owner.id === this.currentUser.id || this.isAdmin
    },
    id () {
      return parseInt(this.$route.params.id)
    },
    tournament () {
      return this.tournamentMap.get(this.id)
    },
    ...mapGetters(['tournamentMap', 'currentUser', 'isAdmin']),
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
    },
    ...mapActions({
      updateTournament: 'UPDATE_TOURNAMENT',
      destroyTournament: 'DESTROY_TOURNAMENT',
    }),
  },
}
</script>
