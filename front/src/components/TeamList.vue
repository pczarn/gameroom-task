<template>
<div>
  <div v-for="team in teamList">
    <team-overview v-bind="team" :editable="false"></team-overview>
  </div>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import TeamOverview from './TeamOverview'

export default {
  beforeMount () {
    // this.$store.dispatch('GET_TEAMS')
  },
  components: {
    TeamOverview,
  },
  computed: mapGetters(['teamList']),
}
</script>

<style scoped>
</style>
