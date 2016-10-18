<template>
  <nav>
    <ul>
      <li>
        <router-link to="/">Home</router-link>
      </li>

      <li v-if="isLoggedIn">
        Hi, {{ currentUser.name }} <br>
        <router-link to="/logout">
          Log out
        </router-link>
      </li>
      <li v-else>
        <router-link to="/login">Log in</router-link>
      </li>
    </ul>
  </nav>
</template>

<script>
  import { mapGetters } from 'vuex'

  export default {
    computed: mapGetters(['currentUser', 'isLoggedIn']),
  }
</script>

<style scoped>
</style>
