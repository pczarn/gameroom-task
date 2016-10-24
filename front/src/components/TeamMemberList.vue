<template>
  <div class="team-members">
    <ul>
      <li v-for="member in members">
        {{ member.name }}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'TeamMemberList',
  props: {
    members: Array,
  },
}
</script>

<style scoped>
ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
}
</style>
