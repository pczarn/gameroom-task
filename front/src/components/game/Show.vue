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
    <router-view></router-view>
  </div>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import policies from 'src/policies'
import * as action from 'src/store/action_types'

export default {
  name: 'Game',
  computed: {
    editable () {
      return policies.gamePolicy(this.game).update
    },
    ...mapGetters({
      game: 'currentGame',
    }),
  },
  methods: {
    async remove () {
      await this.$store.dispatch(action.DESTROY_GAME, this.game)
      this.$router.go(-1)
    },
  },
}
</script>
