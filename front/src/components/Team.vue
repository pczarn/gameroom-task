<template>
  <div class="team">
    <strong>{{name}}</strong>
    <ul>
      <li v-for="member in members">
        <strong>{{member.name}}</strong>
        <button v-if="editable" @click="$emit('remove')">Remove</button>
      </li>
    </ul>
  </div>
</template>

<script>
  import axios from 'axios'

  export default {
    name: 'Team',
    props: {
      id: Number,
      name: String,
      member_ids: Array,
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
