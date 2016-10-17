<template>
<div class="round">
  <h3>Round {{ number }}</h3>
  <ul>
    <li v-for="match in matches">
      <tournament-match :match="match" @remove="remove(match)"></tournament-match>
    </li>
  </ul>
</div>
</template>

<script>
import TournamentMatch from './Match'

export default {
  name: 'TournamentRound',
  components: {
    TournamentMatch,
  },

  props: {
    number: Number,
    matches: Array,
  },
}
</script>
