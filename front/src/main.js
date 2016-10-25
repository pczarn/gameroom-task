import Vue from 'vue'
import VueTimeago from 'vue-timeago'

import App from './App'
import api from 'src/api'
import auth from 'src/auth'
import store from 'src/store'
import router from 'src/router'

Vue.use(VueTimeago, {
  name: 'timeago',
  locale: 'en-US',
  locales: {
    'en-US': require('vue-timeago/locales/en-US.json')
  },
})

new Vue({
  router,
  store,
  render: h => h(App),
  beforeMount () {
    let token = auth.getToken()
    if(token) {
      api.logIn(token)
      let currentUser = auth.getCurrentUser()
      this.$store.commit('SET_CURRENT_USER_AND_TOKEN', { user: currentUser, token: token })
      this.$store.dispatch('GET_EVERYTHING')
    } else {
      this.$router.push('/login')
    }
  },
}).$mount('#app')
