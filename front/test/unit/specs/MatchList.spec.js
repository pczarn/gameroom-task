import Vue from 'vue'
import MatchList from 'src/components/MatchList'

describe('MatchList.vue', () => {
  it('should render correct contents', () => {
    const vm = new Vue({
      el: document.createElement('div'),
      render: (h) => h(MatchList)
    })
    expect(vm.$el.querySelector('h1').textContent).to.equal('Matches')
  })
})
