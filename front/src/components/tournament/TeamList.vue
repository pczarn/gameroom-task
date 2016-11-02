<template>
<div>
  <div v-for="(team, idx) in teams">
    size {{ team.team_size_limit || 'no limit' }}
    <tournament-team-overview v-bind="team"
                              :tournament="tournament">
    </tournament-team-overview>
  </div>
</div>
</template>

<script>
import policies from 'src/policies'
import TournamentTeamOverview from './TeamOverview'

export default {
  components: {
    TournamentTeamOverview,
  },
  props: {
    tournament: Object,
  },
  computed: {
    canEdit () {
      return policies.tournamentPolicy(this.tournament).update
    },
    teams () {
      return this.tournament.teams
    },
  },
}
</script>
