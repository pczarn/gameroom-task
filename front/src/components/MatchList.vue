<template>
<div>
  <h1>Matches</h1>
  <ul class="matches">
    <li v-for="match in matchListForUser">
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
    return {
      newMatch: {},
    }
  },
  props: {
    forUser: Object,
  },
  computed: {
    matchListForUser () {
      let matchList = this.matchList
      if(this.forUser) {
        let userId = this.forUser.id
        matchList = matchList.filter(match => {
          return match.owner_id === userId ||
            match.teamOne && match.teamOne.member_ids.includes(userId) ||
            match.teamTwo && match.teamTwo.member_ids.includes(userId)
        })
      }
      return matchList
    },
    ...mapGetters(['matchList']),
  },
  methods: {
    remove (match) {
      this.$store.dispatch('REMOVE_MATCH', match)
    },
    add () {
      this.$store.dispatch('CREATE_MATCH', this.newMatch).then(_ => { this.newMatch = {} })
    },
  },
}
</script>

<style scoped>
ul.matches > li {
  display: block;
  margin: 10px 0;
}
</style>
