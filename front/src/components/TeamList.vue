<template>
  <div>
    <div v-for="team in teamList">
      <Team v-bind="team" :editable="false"></Team>
    </div>
  </div>
</template>

<script>
  import { mapGetters } from 'vuex'
  import Team from './Team'

  export default {
    beforeMount () {
      // this.$store.dispatch('GET_TEAMS')
    },
    components: {
      Team,
    },
    computed: mapGetters(['teamList']),
  }
</script>

<style scoped>
</style>
