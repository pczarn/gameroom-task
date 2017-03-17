<template>
<form @submit.prevent="submit">
  <fieldset>
    <div :class="{ err: !!formErrors.name }">
      <p v-for="err in formErrors.name || []">{{ err }}</p>
      <label for="username">Name</label>
      <input type="name" v-model="user.name" name="username"> <br>
    </div>

    <div :class="{ err: !!formErrors.email }">
      <p v-for="err in formErrors.email || []">{{ err }}</p>
      <label for="email">Email</label>
      <input type="email" v-model="user.email" name="email"> <br>
    </div>

    <div :class="{ err: !!formErrors.password }">
      <p v-for="err in formErrors.password || []">{{ err }}</p>
      <label for="pass">Password</label>
      <input type="password" v-model="user.password" name="pass"> <br>
    </div>

    <div :class="{ err: !!formErrors.password_confirmation }">
      <p v-for="err in formErrors.password_confirmation || []">{{ err }}</p>
      <label for="pass_confirmation">Confirm the password</label>
      <input type="password" v-model="user.password_confirmation" name="pass_confirmation">
    </div>

    <div :class="{ err: !!formErrors.avatar }">
      <p v-for="err in formErrors.avatar || []">{{ err }}</p>
      <label for="avatar">Avatar</label>
      <input type="image" v-model="user.image" accept="image/*" name="avatar"> <br>
    </div>

    <button type="submit">{{ buttonText }}</button>
  </fieldset>
</form>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  data () {
    return {
      user: {},
    }
  },
  computed: {
    ...mapGetters(['formErrors']),
  },
}
</script>

<style scoped>
.err input {
  border-color: red;
}
</style>
