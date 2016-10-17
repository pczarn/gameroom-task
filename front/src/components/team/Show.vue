<template>
<div class="team" v-if="team">
  <strong>{{ team.name }}</strong>
  <team-member-list :members="team.members"></team-member-list>

  <div v-if="editable">
    Update
    <team-edit></team-edit>
  </div>

  <a href="#" @click.prevent="$router.go(-1)">Go back</a>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import policies from 'src/policies'
import TeamMemberList from './MemberList'
import TeamEdit from './Edit'

export default {
  name: 'Team',
  components: {
    TeamMemberList,
    TeamEdit,
  },

  computed: {
    editable () {
      return policies.teamPolicy(this.team).update
    },
    ...mapGetters({
      team: 'currentTeam',
    }),
  },
}
</script>
