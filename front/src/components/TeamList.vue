<template>
<div v-if="teamList">
  <div v-for="team in filteredTeams">
    <team-overview v-bind="team"></team-overview>
  </div>

  <team-form button-text="Create team"
             :create="true"
             @submit="add">
  </team-form>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import TeamOverview from './TeamOverview'
import TeamForm from './TeamForm'

export default {
  name: 'TeamList',
  components: {
    TeamOverview,
    TeamForm,
  },
  props: {
    user: Object,
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
  methods: {
    add (team) {
      this.$store.dispatch('CREATE_TEAM', team)
    },
  },
}
</script>
