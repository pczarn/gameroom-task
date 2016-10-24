<template>
<div>
  <account-form :value="currentUser" @submit="update"></account-form>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import AccountForm from './AccountForm'

export default {
  name: 'Account',
  components: {
    AccountForm,
  },
  computed: {
    ...mapGetters(['currentUser']),
  },
  methods: {
    update (user) {
      this.$store.dispatch('UPDATE_USER', user)
    },
  },
}
</script>
