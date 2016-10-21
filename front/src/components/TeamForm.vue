<template>
  <div>
    <form @submit.prevent="$emit('submit')">
      <fieldset class="row">
        <legend>Name</legend>
        <input type="text" name="name" v-model="team.name">
      </fieldset>

      <fieldset class="row">
        <legend>Members</legend>
        <!-- <vue-multiselect></vue-multiselect> -->
      </fieldset>

      <button type="submit">{{ button }}</button>
    </form>
  </div>
</template>

<script>
  import { mapGetters } from 'vuex'

  export default {
    name: 'TeamForm',
    props: {
      button: String,
      team: Object,
    },
    computed: mapGetters(['userList']),
  }
</script>

<style scoped>
</style>
