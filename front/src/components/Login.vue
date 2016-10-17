<template>
  <form @submit.prevent="logIn">
    <fieldset>
      <legend>Auth</legend>
      <input type="text" v-model="email">
      <input type="password" v-model="password">
      <button type="submit">Log in</button>
    </fieldset>
    <div class="alert">{{error}}</div>
  </form>
</template>

<script>
  import Vue from 'vue'
  import axios from 'axios'
  import auth from '../auth'

  export default {
    data: function () {
      return {
        email: 'p@monterail.com',
        password: 'hunter2',
        error: ''
      }
    },
    methods: {
      logIn() {
        this.$store.dispatch('LOG_IN', { email: this.email, password: this.password })
      }
    }
  }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1 {
  color: #42b983;
}
</style>
