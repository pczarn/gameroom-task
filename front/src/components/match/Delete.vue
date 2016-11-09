<template>
<div>
  Delete the match.
  <button @click="destroy()">Remove</button>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import { DESTROY_FRIENDLY_MATCH } from 'src/store/action_types'
import policies from 'src/policies'

export default {
  computed: {
    canDestroy () {
      return policies.friendlyMatchPolicy(this.match).destroy
    },
    ...mapGetters({
      match: 'currentMatch',
    }),
  },
  methods: {
    async destroy () {
      await this.$store.dispatch(DESTROY_FRIENDLY_MATCH, this.match)
      this.$router.push('/matches')
    },
  },
}
</script>
