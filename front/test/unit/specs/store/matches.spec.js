import { mutations } from 'src/store/matches'
import { SET_MATCH_LIST, ADD_MATCH } from 'src/store/mutation_types'

describe('mutations', () => {
  describe('SET_MATCH_LIST', () => {
    it('works', () => {
      const state = { matches: [] }
      mutations[SET_MATCH_LIST](state, ['a'])
      expect(state.matches[0]).to.equal('a')
    })
  })
  describe('ADD_MATCH', () => {
    it('works', () => {
      const state = { matches: [] }
      mutations[ADD_MATCH](state, 'b')
      expect(state.matches[0]).to.equal('b')
    })
  })
})
