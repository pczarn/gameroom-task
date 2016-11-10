<template>
<div>
  <round v-for="(round, index) in tournament.rounds"
         :matches="round"
         :number="index">
  </round>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import Round from './Round'

export default {
  name: 'TournamentRoundList',
  components: {
    Round,
  },

  computed: {
    ...mapGetters({
      tournament: 'currentTournament',
    }),
  },

  created () {
    this.ensureRoundsPresent()
  },
  methods: {
    ensureRoundsPresent () {
      if(this.tournament && this.tournament.rounds.length === 0) {
        this.$router.replace({ name: 'tournament teams', params: { id: this.$route.params.id } })
      }
    },
  },
  watch: {
    tournament: 'ensureRoundsPresent',
  },
}
</script>
