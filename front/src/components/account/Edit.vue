<template>
<div>
  <account-form button-text="Update account"
                :value="currentUser"
                @submit="update">
  </account-form>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import AccountForm from './Form'

export default {
  name: 'AccountEdit',
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
