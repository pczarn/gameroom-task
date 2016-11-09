import { mutations } from 'src/store/matches'
import { SET_FRIENDLY_MATCH_LIST, ADD_FRIENDLY_MATCH } from 'src/store/mutation_types'

describe('mutations', () => {
  describe('SET_FRIENDLY_MATCH_LIST', () => {
    it('works', () => {
      const state = { matches: [] }
      mutations[SET_FRIENDLY_MATCH_LIST](state, ['a'])
      expect(state.matches[0]).to.equal('a')
    })
  })
  describe('ADD_FRIENDLY_MATCH', () => {
    it('works', () => {
      const state = { matches: [] }
      mutations[ADD_FRIENDLY_MATCH](state, 'b')
      expect(state.matches[0]).to.equal('b')
    })
  })
})
