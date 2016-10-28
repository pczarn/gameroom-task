<template>
<div class="round">
  <h3>Round {{ number }}</h3>
  <ul>
    <li v-for="match in matches">
      <tournament-match v-bind="match" @remove="remove(match)" :tournament="tournament"></tournament-match>
    </li>
  </ul>
</div>
</template>

<script>
import TournamentMatch from './TournamentMatch'

export default {
  props: {
    number: Number,
    matches: Array,
    tournament: Object,
  },
  components: {
    TournamentMatch,
  },
}
</script>
