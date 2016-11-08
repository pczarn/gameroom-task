<template>
  <div class="team-members">
    <ul>
      <li v-for="member in members">
        {{ member.name }}
        <button v-if="editable" @click.prevent="remove(member)">X</button>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'TeamMemberList',

  props: {
    members: Array,
    editable: {
      type: Boolean,
      default: false,
    },
  },

  methods: {
    remove (member) {
      this.$emit('remove', member)
    },
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
