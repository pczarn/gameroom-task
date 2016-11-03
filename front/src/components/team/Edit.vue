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
import TeamForm from './Form'

export default {
  name: 'TeamEdit',
  mixins: [TeamForm],
  methods: {
    submit () {
      this.$store.dispatch('UPDATE_TEAM', this.team)
    },
  },
}
</script>
