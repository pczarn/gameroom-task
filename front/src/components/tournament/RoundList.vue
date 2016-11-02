<template>
<div>
  <round v-for="(round, index) in tournament.rounds"
         :matches="round"
         :number="index"
         :tournament="tournament">
  </round>
</div>
</template>

<script>
export default {
  props: {
    tournament: Object,
  },
  created () {
    this.ensureRoundsPresent()
  },
  watch: {
    tournament: 'ensureRoundsPresent',
  },
  methods: {
    ensureRoundsPresent () {
      if(this.tournament && this.tournament.rounds.length === 0) {
        this.$router.replace({ name: 'tournament teams', params: { id: this.$route.params.id } })
      }
    },
  },
}
</script>
