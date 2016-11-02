<template>
<div>
  <div v-for="(team, idx) in teams">
    size {{ team.numberOfSlots || 'no limit' }}
    <tournament-team-overview v-bind="team"
                              :tournament="tournamentClone">
    </tournament-team-overview>
  </div>

  <select-team :tournament="tournamentClone" @input="addTeam">
  </select-team>
</div>
</template>

<script>
import _ from 'lodash'
import policies from 'src/policies'
import TournamentTeamOverview from './TeamOverview'
import SelectTeam from './SelectTeam'

export default {
  components: {
    TournamentTeamOverview,
    SelectTeam,
  },
  props: {
    tournament: Object,
  },
  data () {
    return {
      tournamentClone: _.cloneDeep(this.tournament),
    }
  },
  computed: {
    canEdit () {
      return policies.tournamentPolicy(this.tournamentClone).update
    },
    teams () {
      return this.tournament.teams
    },
  },
  methods: {
    addTeam (team) {
      this.tournamentClone.teams.push(team)
      this.$store.dispatch('UPDATE_TOURNAMENT', this.tournamentClone)
    },
  },
}
</script>
