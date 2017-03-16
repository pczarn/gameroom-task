<template>
<div v-if="teamList">
  <h1>Teams</h1>
  <ul>
    <li v-for="team in filteredTeams">
      <team-overview v-bind="team"></team-overview>
    </li>
  </ul>

  <template v-if="notFiltering">
    Create a team
    <team-create></team-create>
  </template>
</div>
<div v-else>
  loading
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
      return list.sort((a, b) => a.createdAt - b.createdAt)
    },
    notFiltering () {
      return this.filterUser === undefined
    },
    ...mapGetters(['teamList', 'filterUser']),
  },
}
</script>
