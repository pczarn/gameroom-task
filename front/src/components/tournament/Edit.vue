<script>
import Vue from 'vue'
import axios from 'axios'
import { mapActions } from 'vuex'
import TournamentForm from './Form'

export default {
  name: 'TournamentEdit',
  mixins: [TournamentForm],
  data () {
    return {
      buttonText: 'Update the tournament',
    }
  },
  methods: {
    async submit () {
      const newTeams = this.tournamentClone.teams.filter(team => team.id === undefined)
      const promises = newTeams.map(team => this.$store.dispatch('CREATE_TEAM'))
      const createdTeams = await axios.all(promises)
      for(const team of createdTeams) {
        this.tournamentClone.teams.push(team)
      }
      this.updateTournament(this.tournamentClone)
    },
    ...mapActions({
      updateTournament: 'UPDATE_TOURNAMENT',
    }),
  },
}
</script>
