<template>
<div class="round">
  <h3>Round {{ number }}</h3>
  <ul>
    <li v-for="match in matches">
      <match v-bind="match" @remove="remove(match)">
    </li>
  </ul>
</div>
</template>

<script>
import axios from 'axios'
import Match from './Match'

export default {
  data () {
    return {
      admin: false,
    }
  },
  props: ['number', 'matches'],
  components: {
    match: Match,
  },
}
</script>

<style scoped>
</style>
