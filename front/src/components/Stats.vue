<template>
<div>
  <h1>Statistics</h1>
  <div v-for="stat in stats">
    In game
    <router-link :to="{ name: 'game stats', params: { id: stat.game.id } }">
      {{ stat.game.name }}
    </router-link>
    , you are placed at {{ stat.place + 1 }}
  </div>
</div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: {
    stats () {
      const userId = this.currentUser.id
      const list = this.gameList.map(game => {
        return { game, place: game.stats.findIndex(stat => stat.user.id == userId) }
      }).filter(stat => stat.place >= 0)
      return list
    },
    ...mapGetters(['currentUser', 'gameList']),
  },
}
</script>
