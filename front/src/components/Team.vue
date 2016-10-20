<template>
<div class="team" v-if="team">
  <strong>{{ team.name }}</strong>
  <team-member-list :members="team.members"></team-member-list>

  Update
  <team-form button="Update team" :team="newTeam" @submit="update()"></team-form>
  <a href="#" @click.prevent="$router.go(-1)">Go back</a>
</div>
</template>

<script>
import Vue from 'vue'
import { mapGetters } from 'vuex'
import TeamMemberList from './TeamMemberList'
import TeamForm from './TeamForm'

export default {
  name: 'Team',
  components: {
    TeamMemberList,
    TeamForm,
  },
  data () {
    return {
      editable: false,
      newTeam: {},
    }
  },
  computed: {
    id () {
      return parseInt(this.$route.params.id)
    },
    team () {
      return this.teamMap.get(this.id)
    },
    ...mapGetters(['teamMap']),
  },
  methods: {
    update () {
      this.$store.dispatch('UPDATE_TEAM', this.newTeam)
    },
  },
  watch: {
    team (newValue) {
      this.newTeam = Vue.util.extend({}, newValue)
      // if(newValue) {
      //   this.newTeam.id = newValue.id
      // }
    },
  },
}
</script>

<style scoped>
h1 {
  color: #42b983;
}
</style>
