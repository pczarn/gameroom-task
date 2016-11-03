<template>
<button @click="destroy">Remove</button>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters({
      game: 'currentGame',
    }),
  },
  methods: {
    async destroy () {
      await this.$store.dispatch('DESTROY_GAME', this.game)
      this.$router.go('/games')
    },
  },
}
</script>
