<template>
<div>
  <h1>Matches</h1>
  <ul class="matches">
    <li v-for="match in filteredMatches">
      <match-overview v-bind="match" @remove="remove(match)"></match-overview>
    </li>
  </ul>

  <h2>Add a match</h2>
  <match-form button-text="Add the match"
              clear-on-submit
              @submit="add">
  </match-form>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import MatchOverview from './MatchOverview'
import MatchForm from './MatchForm'

export default {
  name: 'MatchList',
  props: {
    user: Object,
    game: Object,
  },
  components: {
    MatchOverview,
    MatchForm,
  },
  computed: {
    filteredMatches () {
      let matchList = this.matchList
      if(this.user) {
        const userId = this.user.id
        matchList = matchList.filter(match => {
          return match.owner.id === userId ||
            match.teamOne && match.teamOne.members.some(m => m.id === userId) ||
            match.teamTwo && match.teamTwo.members.some(m => m.id === userId)
        })
      }
      if(this.game) {
        matchList = matchList.filter(match => match.game.id === this.game.id)
      }
      return matchList
    },
    ...mapGetters(['matchList']),
  },
  methods: {
    remove (match) {
      this.$store.dispatch('REMOVE_MATCH', match)
    },
    add (newMatch) {
      this.$store.dispatch('CREATE_MATCH', newMatch)
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
