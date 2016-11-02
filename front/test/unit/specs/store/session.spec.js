import { mutations } from 'src/store/session'
import { SET_CURRENT_USER_AND_TOKEN, RESET_CURRENT_USER_AND_TOKEN } from 'src/store/mutation_types'

describe('mutations', () => {
  describe('SET_CURRENT_USER_AND_TOKEN', () => {
    it('works', () => {
      const state = { currentUser: null, sessionToken: null }
      mutations[SET_CURRENT_USER_AND_TOKEN](state, { user: 'user', token: 'token' })
      expect(state.currentUser).to.equal('user')
      expect(state.sessionToken).to.equal('token')
    })
  })
  describe('RESET_CURRENT_USER_AND_TOKEN', () => {
    it('works', () => {
      const state = { currentUser: 'a', sessionToken: 'b' }
      mutations[RESET_CURRENT_USER_AND_TOKEN](state)
      expect(state.currentUser).to.equal(null)
      expect(state.sessionToken).to.equal(null)
    })
  })
})
