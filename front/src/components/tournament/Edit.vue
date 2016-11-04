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
      const newTeams = this.tournament.teams.filter(team => team.id === undefined)
      const promises = newTeams.map(team => this.$store.dispatch(action.CREATE_TEAM))
      const createdTeams = await axios.all(promises)
      for(const team of createdTeams) {
        this.tournament.teams.push(team)
      }
      this.updateTournament(this.tournament)
    },
    ...mapActions({
      updateTournament: 'UPDATE_TOURNAMENT',
    }),
  },
}
</script>
