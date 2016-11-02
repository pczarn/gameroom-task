<template>
<div class="game" v-if="game">
  <img :src="game.image_thumb_url">
  <strong>{{ game.name }}</strong>

  <router-link :to="{ name: 'game tournaments', params: { id: game.id } }">Tournaments</router-link>

  <router-link :to="{ name: 'game matches', params: { id: game.id } }">Matches</router-link>

  <router-link :to="{ name: 'game edit', params: { id: game.id } }" v-if="editable">
    Edit
  </router-link>

  <router-link :to="{ name: 'game remove', params: { id: game.id } }" v-if="editable">
    Remove
  </router-link>

  Statistics

  <div>
    <router-view :game="game"></router-view>
  </div>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import policies from 'src/policies'

export default {
  name: 'Game',
  computed: {
    id () {
      return parseInt(this.$route.params.id)
    },
    game () {
      return this.gameMap.get(this.id)
    },
    editable () {
      return policies.gamePolicy(this.game).update
    },
    ...mapGetters(['gameMap']),
  },
  methods: {
    async remove () {
      await this.$store.dispatch('DESTROY_GAME', this.game)
      this.$router.go(-1)
    },
  },
}
</script>
