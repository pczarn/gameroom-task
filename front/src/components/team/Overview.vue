<template>
<div class="team">
  <strong>{{name}}</strong>
  <team-member-list :members="members"></team-member-list>
  <router-link :to="{ name: 'team', params: { id } }">See more</router-link>
</div>
</template>

<script>
import TeamMemberList from './MemberList'

export default {
  name: 'TeamOverview',
  components: {
    TeamMemberList,
  },

  props: {
    id: Number,
    name: String,
    members: Array,
  },
}
</script>
