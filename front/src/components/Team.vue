<template>
<div class="team">
  <strong>{{name}}</strong>
  <TeamMemberList :members="members"></TeamMemberList>
</div>
</template>

<script>
export default {
  name: 'Team',
  props: {
    id: Number,
    name: String,
    member_ids: Array,
  },
  components: {
    TeamMembers,
  },
  data () {
    return {
      editable: false,
    }
  },
  computed: {
    members () {
      let users = this.$store.getters.userMap
      return this.member_ids.map(id => users.get(id))
    }
  },
}
</script>

<style scoped>
h1 {
  color: #42b983;
}
</style>
