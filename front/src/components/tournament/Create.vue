<script>
import _ from 'lodash'
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
      await this.$store.dispatch('CREATE_TOURNAMENT', this.tournament)
      this.tournament = _.cloneDeep(this.blankTournament)
    },
  },
}
</script>
