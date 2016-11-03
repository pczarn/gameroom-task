<template>
<div>
  <h1>Matches</h1>
  <ul class="matches">
    <li v-for="match in filteredMatches">
      <match-overview v-bind="match"></match-overview>
    </li>
  </ul>

  <h2>Add a match</h2>
  <match-create></match-create>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import MatchOverview from './Overview'
import MatchCreate from './Create'

export default {
  name: 'MatchList',
  props: {
    user: Object,
  },
  components: {
    MatchOverview,
    MatchCreate,
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
    ...mapGetters({
      matchList: 'matchList',
      game: 'currentGame',
    }),
  },
}
</script>

<style scoped>
ul.matches > li {
  display: block;
  margin: 10px 0;
}
</style>
