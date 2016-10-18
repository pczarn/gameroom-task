<template>
  <nav>
    <ul>
      <li>
        <router-link to="/">Home</router-link>
      </li>

      <li v-if="isLoggedIn">
        Hi, {{ currentUser.name }} <br>
        <a href="#" @mouseup="logout()">
          Log out
        </a>
      </li>
      <li v-else>
        <router-link to="/login">Log in</router-link>
      </li>
    </ul>
  </nav>
</template>

<script>
  import { mapGetters } from 'vuex'
  import auth from 'src/auth'

  export default {
    computed: mapGetters(['currentUser', 'isLoggedIn']),
    methods: {
      logout () {
        auth.logOut()
        this.$store.commit('RESET_CURRENT_USER')
        this.$router.push('/logout')
      },
    },
  }
</script>

<style scoped>
</style>
