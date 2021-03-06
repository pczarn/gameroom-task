import api from 'src/api'
import router from 'src/router'

// Session related constants
const SESSION_KEY = 'sessionData'
const CURRENT_USER_KEY = 'currentUserData'

export default {
  // Send a request to the login URL and save the returned JWT
  logIn ({ user, token }) {
    localStorage.setItem(CURRENT_USER_KEY, JSON.stringify(user))
    localStorage.setItem(SESSION_KEY, token)
    api.logIn(token)
  },

  // To log out, we just need to remove the token
  logOut () {
    localStorage.removeItem(CURRENT_USER_KEY)
    localStorage.removeItem(SESSION_KEY)
    api.logOut()
    router.push('/logout')
  },

  getToken () {
    return localStorage.getItem(SESSION_KEY)
  },

  getCurrentUser () {
    const stringifiedInfo = localStorage.getItem(CURRENT_USER_KEY)
    return stringifiedInfo && JSON.parse(stringifiedInfo)
  },
}
