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
  <account-create></account-create>
</div>
</template>

<script>
import * as action from 'src/store/action_types'
import AccountCreate from 'src/components/account/Create'

export default {
  name: 'Login',
  components: {
    AccountCreate,
  },

  data () {
    return {
      email: 'p@monterail.com',
      password: 'hunter2',
      error: '',
    }
  },

  methods: {
    logIn () {
      try {
        this.$store.dispatch(action.LOG_IN, { email: this.email, password: this.password })
      } catch(err) {
        this.error = err
      }
    },
  },
}
</script>
