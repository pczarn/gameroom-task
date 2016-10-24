<template>
<div>
  Log in
  <form @submit.prevent="logIn">
    <fieldset>
      <legend>Auth</legend>
      <input type="text" v-model="email">
      <input type="password" v-model="password">
      <button type="submit">Log in</button>
    </fieldset>
    <div class="alert">{{ error }}</div>
  </form>
  Register
  <register></register>
</div>
</template>

<script>
import Register from './Register'

export default {
  name: 'Login',
  components: {
    Register,
  },
  data: function () {
    return {
      email: 'p@monterail.com',
      password: 'hunter2',
      error: '',
    }
  },
  methods: {
    logIn () {
      try {
        this.$store.dispatch('LOG_IN', { email: this.email, password: this.password })
      } catch(err) {
        this.error = err
      }
    },
  },
}
</script>

<style scoped>
h1 {
  color: #42b983;
}
</style>
