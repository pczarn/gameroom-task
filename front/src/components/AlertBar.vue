<template>
<div v-show="alert">
  {{ alert }}
  <a href="#" @click.prevent="clear">X</a>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import * as action from 'src/store/action_types'

export default {
  name: 'AlertBar',

  computed: mapGetters(['alert']),

  methods: {
    clear () {
      this.$store.dispatch(action.SET_ERROR, null)
    },
  },
}
</script>

<style scoped>
div {
  background-color: yellow;
}
</style>
