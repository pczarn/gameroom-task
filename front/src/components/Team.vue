<template>
<div class="team" v-if="team">
  <strong>{{ team.name }}</strong>
  <team-member-list :members="team.members"></team-member-list>

  <div v-if="editable">
    Update
    <team-form button-text="Update team"
               :value="team"
               @submit="update">
    </team-form>
  </div>

  <a href="#" @click.prevent="$router.go(-1)">Go back</a>
</div>
</template>

<script>
import Vue from 'vue'
import { mapGetters } from 'vuex'
import TeamMemberList from './TeamMemberList'
import TeamForm from './TeamForm'
import policies from 'src/policies'

export default {
  name: 'Team',
  components: {
    TeamMemberList,
    TeamForm,
  },
  computed: {
    id () {
      return parseInt(this.$route.params.id)
    },
    team () {
      return this.teamMap.get(this.id)
    },
    editable () {
      return policies.teamPolicy(this.team).update
    },
    ...mapGetters(['teamMap']),
  },
  methods: {
    update (newTeam) {
      this.$store.dispatch('UPDATE_TEAM', newTeam)
    },
  },
}
</script>

<style scoped>
h1 {
  color: #42b983;
}
</style>
