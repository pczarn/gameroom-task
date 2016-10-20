<template>
<div class="team">
  <strong>{{name}}</strong>
  <team-member-list :members="members"></team-member-list>
  <router-link :to="{ name: 'team', params: { id } }">See more</router-link>
</div>
</template>

<script>
import TeamMemberList from './TeamMemberList'

export default {
  name: 'TeamOverview',
  props: {
    id: Number,
    name: String,
    members: Array,
  },
  components: {
    TeamMemberList,
  },
  data () {
    return {
      editable: false,
    }
  },
  computed: {
  },
}
</script>

<style scoped>
h1 {
  color: #42b983;
}
</style>
