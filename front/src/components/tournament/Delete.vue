<template>
<div>
  Delete the tournament.
  <button v-if="canDestroy" @click="destroy">Delete</button>
</div>
</template>

<script>
import { mapActions } from 'vuex'
import policies from 'src/policies'

export default {
  props: {
    tournament: Object,
  },
  computed: {
    canDestroy () {
      return policies.tournamentPolicy(this.tournament).destroy
    },
  },
  methods: {
    destroy () {
      this.destroyTournament(this.tournament)
      this.$router.push('/tournaments')
    },
    ...mapActions({
      destroyTournament: 'DESTROY_TOURNAMENT',
    }),
  },
}
</script>
