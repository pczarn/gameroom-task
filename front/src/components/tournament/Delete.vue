<template>
<div>
  Delete the tournament.
  <button type="button" @click="destroy">Delete</button>
</div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import policies from 'src/policies'

export default {
  name: TournamentDelete,

  computed: {
    ...mapGetters({
      tournament: 'currentTournament',
    }),
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
