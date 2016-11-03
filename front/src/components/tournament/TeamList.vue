<template>
<div v-if="tournament">
  <div v-for="(team, idx) in teams">
    size {{ team.numberOfSlots || 'no limit' }}
    <tournament-team-overview v-bind="team"
                              :tournament="tournament">
    </tournament-team-overview>
  </div>

  <select-team :tournament="tournament" @input="addTeam">
  </select-team>
</div>
</template>

<script>
import _ from 'lodash'
import { mapGetters } from 'vuex'
import policies from 'src/policies'
import TournamentTeamOverview from './TeamOverview'
import SelectTeam from './SelectTeam'

export default {
  components: {
    TournamentTeamOverview,
    SelectTeam,
  },
  data () {
    return {
      tournament: null,
    }
  },
  created () {
    this.tournament = _.cloneDeep(this.currentTournament)
  },
  computed: {
    canEdit () {
      return policies.tournamentPolicy(this.tournament).update
    },
    teams () {
      return this.tournament.teams
    },
    ...mapGetters(['currentTournament']),
  },
  methods: {
    addTeam (team) {
      this.tournament.teams.push(team)
      this.$store.dispatch('UPDATE_TOURNAMENT', this.tournament)
    },
  },
}
</script>
