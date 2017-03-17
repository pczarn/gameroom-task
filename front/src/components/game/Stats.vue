<template>
<div>
  <table>
    <thead>
      <tr>
        <th>Place</th>
        <th>Player</th>
        <th>Score</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="(stat, idx) in currentGame.stats">
        <td>{{ idx + 1 }}</td>
        <td :class="{ bold: stat.user.id === currentUser.id }">
          {{ stat.user.name }}
        </td>
        <td>{{ stat.value }}</td>
      </tr>
    </tbody>
  </table>
</div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters(['currentUser', 'gameList', 'currentGame']),
  },
}
</script>

<style scoped>
td.bold {
  font-weight: bold;
}
</style>
