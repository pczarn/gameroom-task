<script>
import _ from 'lodash'
import * as action from 'src/store/action_types'
import TournamentForm from './Form'

export default {
  name: 'TournamentCreate',
  mixins: [TournamentForm],

  data () {
    return {
      buttonText: 'Create the tournament',
    }
  },

  methods: {
    async submit () {
      await this.$store.dispatch(action.CREATE_TOURNAMENT, this.tournament)
      this.tournament = this.$options.data().tournament
    },
  },
}
</script>
