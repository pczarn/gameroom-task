<template>
<div>
  <account-form button-text="Register"
                @submit="register">
  </account-form>
</div>
</template>

<script>
import AccountForm from 'src/components/account/Form'

export default {
  components: {
    AccountForm,
  },
  methods: {
    register (user) {
      this.$store.dispatch('CREATE_USER', user)
    },
  },
}
</script>
