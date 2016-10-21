<template>
<div>
  <form @submit.prevent="register">
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
    <div class="alert">{{ error }}</div>
  </form>
</div>
</template>

<script>
export default {
  data: function () {
    return {
      // userFields: [
      //   { name: 'name', type: 'text' },
      //   { name: 'image', type: 'file', accept: 'image/*' },
      //   { name: 'email', type: 'email' },
      //   { name: 'password', type: 'password' },
      //   { name: 'password_confirmation', type: 'password' },
      // ],
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
    async register () {
      try {
        await this.$store.dispatch('CREATE_USER', this.user)
      } catch(err) {
        this.error = err.response.data.error
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
