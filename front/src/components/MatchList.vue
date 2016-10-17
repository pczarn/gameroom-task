<template>
  <div>
    <h1>Matches</h1>
    <ul class="matches">
      <li v-for="match in matchList">
        <Match v-bind="match" @remove="remove(match)"></Match>
      </li>
    </ul>

    <h2>Add a match</h2>
    <form @submit.prevent>
      <fieldset>
        <legend>Properties</legend>
        <template v-for="attrs in fields">
          <label :for="attrs.name">{{attrs.name}}</label>
          <input v-bind="attrs" v-model="new_match[attrs.name]">
          <hr>
        </template>
      </fieldset>
      <fieldset>
        <legend>Choose game</legend>
        <select v-model="new_match.game_id">
          <option v-for="game in games" :value="game.id">{{game.name}}</option>
        </select>
      </fieldset>
      <fieldset>
        <legend>Choose teams</legend>
        <select v-model="new_match.team_one_id">
          <option v-for="team in teams" :value="team.id">{{team.name}}</option>
        </select>
        <select v-model="new_match.team_two_id">
          <option v-for="team in teams" :value="team.id">{{team.name}}</option>
        </select>
      </fieldset>
      <fieldset>
        <legend>Score</legend>
        <input type="number" v-model="new_match.team_one_score">
        <input type="number" v-model="new_match.team_two_score">
      </fieldset>
      <button type="submit" @click="add()">Add the match</button>
    </form>
  </div>
</template>

<script>
  import { mapGetters } from 'vuex'
  import Match from './Match'

  export default {
    name: 'MatchList',
    data () {
      return {
        new_match: {},
        fields: [
          { name: 'played_at', type: 'time' },
        ],
      }
    },
    components: {
      Match,
    },
    methods: {
      add() {
        this.$store.dispatch('CREATE_MATCH').then(_ => { this.new_match = {} })
      },
      remove(match) {
        this.$store.dispatch('REMOVE_MATCH', match)
      },
    },
    computed: mapGetters(['matchList']),
  }
</script>

<style scoped>
ul.matches > li {
  display: block;
  margin: 10px 0;
}
</style>
