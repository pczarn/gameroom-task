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
      members: Array,
      // editable: Boolean,
    },
  }
</script>

<style scoped>
</style>
