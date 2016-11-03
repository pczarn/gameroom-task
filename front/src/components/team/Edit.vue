<template>
<div>
  <form @submit.prevent="submit">
    <fieldset class="row">
      <legend>Name</legend>
      <input type="text" name="name" v-model="team.name">
    </fieldset>

    <button type="submit">Update team</button>
  </form>
</div>
</template>

<script>
import _ from 'lodash'
import { mapGetters } from 'vuex'
import TeamForm from './Form'

export default {
  name: 'TeamEdit',
  mixins: [TeamForm],
  computed: {
    ...mapGetters(['currentTeam']),
  },
  methods: {
    submit () {
      this.$store.dispatch('UPDATE_TEAM', this.team)
    },
  },
  created () {
    this.team = _.cloneDeep(this.currentTeam)
  },
}
</script>
