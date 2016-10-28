<template>
<div v-if="teamList">
  <div v-for="team in filteredTeams">
    <team-overview v-bind="team"></team-overview>
  </div>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import TeamOverview from './TeamOverview'

export default {
  name: 'TeamList',
  props: {
    user: Object,
  },
  components: {
    TeamOverview,
  },
  computed: {
    filteredTeams () {
      let list = this.teamList
      if(this.user) {
        list = list.filter(team => team.members.some(m => m.id === this.user.id))
      }
      return list
    },
    ...mapGetters(['teamList']),
  },
}
</script>
