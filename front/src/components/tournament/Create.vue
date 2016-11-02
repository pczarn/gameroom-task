<script>
import Vue from 'vue'
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
      await this.$store.dispatch('CREATE_TOURNAMENT', this.tournamentClone)
      this.tournamentClone = { teams: [], game: {} }
    },
  },
}
</script>
