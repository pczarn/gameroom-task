<template>
<div>
  <account-form :value="currentUser" @submit="update"></account-form>
</div>
</template>

<script>
import Vue from 'vue'
import { mapGetters } from 'vuex'
import AccountForm from './AccountForm'

export default {
  // data () {
  //   return { user: this.currentUser || {} }
  // },
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
  // watch: {
  //   '$store.getters.currentUser' () {
  //     console.log(this.currentUser)
  //     this.user = Vue.util.extend({}, this.currentUser)
  //   },
  // },
}
</script>
