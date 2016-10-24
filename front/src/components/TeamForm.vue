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

      <button type="submit">{{ buttonText }}</button>
    </form>
  </div>
</template>

<script>
import Vue from 'vue'
import { mapGetters } from 'vuex'

export default {
  name: 'TeamForm',
  props: {
    value: Object,
    buttonText: String,
  },
  data () {
    return {
      team: Vue.util.extend({}, this.value),
    }
  },
  computed: mapGetters(['userList']),
}
</script>

<style scoped>
</style>
