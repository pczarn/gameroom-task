<template>
<div v-if="tournament">
  <ul>
    <li v-for="(team, idx) in teams">
      size {{ team.numberOfSlots || 'no limit' }}
      <tournament-team-overview v-bind="team"
                                :tournament="tournament">
      </tournament-team-overview>
    </li>
  </ul>
</div>
</template>

<script>
import _ from 'lodash'
import { mapGetters } from 'vuex'
import policies from 'src/policies'
import TournamentTeamOverview from './TeamOverview'
import SelectTeam from './SelectTeam'
import * as action from 'src/store/action_types'

export default {
  name: 'TournamentTeamList',
  components: {
    TournamentTeamOverview,
    SelectTeam,
  },

  data () {
    return {
      tournament: null,
    }
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

  created () {
    this.tournament = _.cloneDeep(this.currentTournament)
  },
  methods: {
    addTeam (team) {
      this.tournament.teams.push(team)
      this.$store.dispatch(action.UPDATE_TOURNAMENT, this.tournament)
    },
  },
}
</script>
