<template>
<nav v-if="isLoggedIn">
  <ul>
    <li>
      <router-link to="/">Home</router-link>
    </li>

    <li>
      Hi, {{ currentUser.name }} <br>
      <router-link to="/account">Your account</router-link>
      <a href="#" @mouseup="logOut()">
        Log out
      </a>
    </li>
  </ul>
  <div>
    <router-link to="/dashboard/tournaments">Your tournaments</router-link>
    <router-link to="/dashboard/matches">Your matches</router-link>
    <router-link to="/dashboard/teams">Your teams</router-link>
    Your stats
    <router-link to="/teams">Team list</router-link>
    <router-link to="/tournaments">All tournament list</router-link>
    <router-link to="/matches">All match list</router-link>
    <router-link to="/games">Game list</router-link>
  </div>
</nav>
<nav v-else>
  <ul>
    <router-link to="/login">Log in</router-link>
  </ul>
</nav>
</template>

<script>
import { mapGetters } from 'vuex'
import * as action from 'src/store/action_types'

export default {
  name: 'NavigationBar',
  computed: mapGetters(['currentUser', 'isLoggedIn']),

  methods: {
    logOut () {
      this.$store.dispatch(action.LOG_OUT)
      this.$router.push('/login')
    },
  },
}
</script>
