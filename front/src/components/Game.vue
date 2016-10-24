<template>
<div class="game" v-if="game">
  <img :src="game.image_thumb_url">
  <strong>{{ game.name }}</strong>
  <button v-if="editable" @click="remove">Remove</button>
  <router-link :to="{ name: 'game tournaments', params: { id: game.id } }">Tournaments</router-link>
  <router-link :to="{ name: 'game matches', params: { id: game.id } }">Matches</router-link>
  <router-view :game="game"></router-view>
</div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  data () {
    return {
    }
  },
  computed: {
    id () {
      return parseInt(this.$route.params.id)
    },
    game () {
      return this.gameMap.get(this.id)
    },
    editable () {
      return true
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
