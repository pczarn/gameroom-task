<template>
<div class="tournaments">
  <h1>Tournaments</h1>
  <ul>
    <li v-for="tournament in tournamentList" :key="tournament.id">
      <TournamentOverview v-bind="tournament"></TournamentOverview>
    </li>
  </ul>

  <h2>Add a tournament</h2>
  <form @submit.prevent>
    <fieldset>
      <legend>Properties</legend>
      <template v-for="attrs in fields">
        <label :for="attrs.name">{{ attrs.name }}</label>
        <input v-bind="attrs" v-model="new_tournament[attrs.name]">
        <br>
      </template>
    </fieldset>
    <fieldset>
      <legend>Choose game</legend>
      <select v-model="new_tournament.game_id">
        <option v-for="game in gameList" :value="game.id">{{ game.name }}</option>
      </select>
    </fieldset>
    <fieldset>
      <legend>Choose teams</legend>
      <select v-model="new_tournament.team_one_id">
        <option v-for="team in teamList" :value="team.id">{{ team.name }}</option>
      </select>
      <select v-model="new_tournament.team_two_id">
        <option v-for="team in teamList" :value="team.id">{{ team.name }}</option>
      </select>
    </fieldset>
    <button type="submit" @click="add()">Add the tournament</button>
  </form>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import TournamentOverview from './TournamentOverview'

export default {
  name: 'TournamentList',
  data () {
    return {
      new_tournament: {},
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
  beforeMount () {
    // api.tournaments().then((tournamentsData) => { this.tournaments = tournamentsData })
  },
  methods: {
    async add () {
      let data = await this.$store.dispatch('CREATE_TOURNAMENT', this.new_tournament)
      this.tournaments.push(data)
      this.new_tournament = {}
    },
    async remove (tournament) {
      await this.$store.dispatch('DESTROY_TOURNAMENT', tournament.id)
      let idx = this.tournaments.indexOf(tournament)
      this.tournaments.splice(idx, 1)
    },
  },
  computed: {
    ...mapGetters(['tournamentList', 'gameList', 'teamList'])
  },
}
</script>

<style scoped>
</style>
