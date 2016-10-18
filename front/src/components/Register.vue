<template>
  <div>
    <form @submit.prevent="register">
      <fieldset>
        <legend>Registration</legend>
        <label for="name">Name</label>
        <input type="name" v-model="user.name">
        <label for="email">Email</label>
        <input type="email" v-model="user.email">
        <input type="password" v-model="user.password">
        <input type="password" v-model="user.password_confirmation">
        <input type="image" v-model="user.image">
        <button type="submit">Register</button>
      </fieldset>
      <div class="alert">{{ error }}</div>
    </form>
  </div>
</template>

<script>
  export default {
    data: function () {
      return {

        userFields: [
          { name: 'name', type: 'text' },
          { name: 'image', type: 'file', accept: 'image/*' },
          { name: 'email', type: 'email' },
          { name: 'password', type: 'password' },
          { name: 'password_confirmation', type: 'password' },
        ],
        user: {
          name: '',
          email: '',
          password: '',
          password_confirmation: '',
          image: '',
        },
        error: '',
      }
    },
    methods: {
      register() {
        try {
          this.$store.dispatch('CREATE_USER', this.user)
        } catch(err) {
          this.error = err
        }
      }
    },
  }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1 {
  color: #42b983;
}
</style>
