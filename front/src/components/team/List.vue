<template>
<div v-if="teamList">
  <ul>
    <li v-for="team in filteredTeams">
      <team-overview v-bind="team"></team-overview>
    </li>
  </ul>

  <team-create></team-create>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import TeamOverview from './Overview'
import TeamCreate from './Create'

export default {
  name: 'TeamList',
  components: {
    TeamOverview,
    TeamCreate,
  },

  props: {
    user: Object,
  },
  computed: {
    filteredTeams () {
      let list = this.teamList
      if(this.filterUser) {
        const userId = this.filterUser.id
        list = list.filter(team => team.members.some(m => m.id === userId))
      }
      return list
    },
    ...mapGetters(['teamList', 'filterUser']),
  },
}
</script>
