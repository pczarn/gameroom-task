<template>
<div>
  <account-form @submit="register"></account-form>
  <div class="alert">{{ error }}</div>
</div>
</template>

<script>
import AccountForm from './AccountForm'

export default {
  data: function () {
    return {
      error: '',
    }
  },
  components: {
    AccountForm,
  },
  methods: {
    async register (user) {
      try {
        await this.$store.dispatch('CREATE_USER', user)
      } catch(err) {
        this.error = err.response.data.error
      }
    },
  },
}
</script>
