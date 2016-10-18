<template>
  <div class="team-members">
    <ul>
      <li v-for="member in members">
        <strong>{{ member.name }}</strong>
      </li>
    </ul>
  </div>
</template>

<script>
  export default {
    name: 'TeamMemberList',
    props: {
      member_ids: Array,
      editable: Boolean,
    },
    computed: {
      members () {
        let users = this.$store.getters.userMap
        return this.member_ids.map(id => users.get(id))
      },
    },
  }
</script>

<style scoped>
</style>
