import Vue from 'vue'
import MatchList from 'src/components/match/List'
import { store } from 'src/store'

describe('List.vue', () => {
  it('should render correct contents', () => {
    const vm = new Vue({
      data () {
        return {
          user: null,
          game: null,
        }
      },
      store,
      render: h => h(MatchList),
    }).$mount()
    expect(vm.$el.querySelector('h1').textContent).to.eq('Matches')
  })
})
