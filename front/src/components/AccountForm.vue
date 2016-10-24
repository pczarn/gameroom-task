<template>
<form @submit.prevent="submit">
  <fieldset>
    <label for="username">Name</label>
    <input type="name" v-model="user.name" name="username"> <br>

    <label for="email">Email</label>
    <input type="email" v-model="user.email" name="email"> <br>

    <label for="pass">Password</label>
    <input type="password" v-model="user.password" name="pass"> <br>

    <label for="pass_confirmation">Confirm the password</label>
    <input type="password" v-model="user.password_confirmation" name="pass_confirmation"> <br>

    <label for="avatar">Avatar</label>
    <input type="image" v-model="user.image" accept="image/*" name="avatar"> <br>

    <button type="submit">Register</button>
  </fieldset>
</form>
</template>

<script>
import Vue from 'vue'

export default {
  props: {
    value: Object,
  },
  data () {
    return { user: Vue.util.extend({}, this.value) }
  },
  methods: {
    submit (event) {
      this.$emit('submit', this.user)
    },
  },
}
</script>
