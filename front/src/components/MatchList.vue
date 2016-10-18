<template>
<div>
  <h1>Matches</h1>
  <ul class="matches">
    <li v-for="match in matchList">
      <match-overview v-bind="match" @remove="remove(match)"></match-overview>
    </li>
  </ul>

  <h2>Add a match</h2>
  <match-form :match="newMatch" button="Add the match" @submit="add()"></match-form>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import MatchOverview from './MatchOverview'
import MatchForm from './MatchForm'

export default {
  name: 'MatchList',
  components: {
    MatchOverview,
    MatchForm,
  },
  data () {
  },
  methods: {
    remove (match) {
      this.$store.dispatch('REMOVE_MATCH', match)
    },
    add () {
      this.$store.dispatch('CREATE_MATCH', this.newMatch).then(_ => { this.newMatch = {} })
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
