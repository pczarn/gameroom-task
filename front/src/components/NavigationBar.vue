<template>
<nav>
  <ul>
    <li>
      <router-link to="/">Home</router-link>
    </li>

    <li v-if="isLoggedIn">
      Hi, {{ currentUser.name }} <br>
      <router-link to="/account">Your account</router-link>
      <a href="#" @mouseup="logOut()">
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
import * as action from 'src/store/action_types'

export default {
  computed: mapGetters(['currentUser', 'isLoggedIn']),
  methods: {
    logOut () {
      this.$store.dispatch(action.LOG_OUT)
      this.$router.push('/login')
    },
  },
}
</script>
