<template>
<button @click="destroy">Remove</button>
</template>

<script>
import { mapGetters } from 'vuex'
import * as action from 'src/store/action_types'

export default {
  computed: {
    ...mapGetters({
      game: 'currentGame',
    }),
  },

  methods: {
    async destroy () {
      await this.$store.dispatch(action.DESTROY_GAME, this.game)
      this.$router.go('/games')
    },
  },
}
</script>
