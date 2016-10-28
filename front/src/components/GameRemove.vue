<template>
<button @click="destroy">Remove</button>
</template>

<script>
export default {
  props: {
    game: Object,
  },
  methods: {
    async destroy () {
      await this.$store.dispatch('DESTROY_GAME', this.game)
      this.$router.go('/games')
    },
  },
}
</script>
