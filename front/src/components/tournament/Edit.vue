<script>
import _ from 'lodash'
import axios from 'axios'
import { mapActions } from 'vuex'
import * as action from 'src/store/action_types'
import TournamentForm from './Form'

export default {
  name: 'TournamentEdit',
  mixins: [TournamentForm],

  data () {
    return {
      buttonText: 'Update the tournament',
    }
  },

  created () {
    this.tournament = _.cloneDeep(this.currentTournament)
  },
  methods: {
    async submit () {
      this.updateTournament(this.tournament)
    },
    ...mapActions({
      updateTournament: 'UPDATE_TOURNAMENT',
    }),
  },
}
</script>
