<template>
<div v-show="alert">
  {{ alert }}
  <a href="#" @click.prevent="clear">X</a>
</div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: mapGetters(['alert']),
  methods: {
    clear () {
      this.$store.commit('SET_ERROR', null)
    },
  },
}
</script>

<style scoped>
div {
  background-color: yellow;
}
</style>
