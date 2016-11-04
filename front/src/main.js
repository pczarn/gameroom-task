import Vue from 'vue'
import VueTimeago from 'vue-timeago'
import { sync } from 'vuex-router-sync'

import App from 'src/App'
import api from 'src/api'
import auth from 'src/auth'
import store from 'src/store'
import router from 'src/router'
import * as mutation from 'src/store/mutation_types'
import * as action from 'src/store/action_types'

Vue.use(VueTimeago, {
  name: 'timeago',
  locale: 'en-US',
  locales: {
    'en-US': require('vue-timeago/locales/en-US.json')
  },
})

sync(store, router)

new Vue({
  router,
  store,
  render: h => h(App),
  beforeMount () {
    const token = auth.getToken()
    if(token) {
      api.logIn(token)
      const currentUser = auth.getCurrentUser()
      this.$store.commit(mutation.SET_CURRENT_USER_AND_TOKEN, { user: currentUser, token: token })
      this.$store.dispatch(action.GET_EVERYTHING)
    } else {
      this.$router.push('/login')
    }
  },
}).$mount('#app')
