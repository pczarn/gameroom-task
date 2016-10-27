<template>
<div>
  <div v-for="(team, idx) in teams">
    size {{ team.team_size_limit || 'no limit' }}
    <tournament-team-overview v-bind="team"
                              :tournament="tournament"
                              @join="join"
                              @leave="leave"
                              @add-member="addMember(team, $event)"
                              @remove-member="removeMember(team, $event)">
    </tournament-team-overview>
  </div>
</div>
</template>

<script>
import policies from 'src/policies'
import TournamentTeamOverview from './TournamentTeamOverview'
// import { mapGetters } from 'vuex'
import _ from 'lodash'

export default {
  props: {
    tournament: Object,
    // joinable: Boolean,
    editable: Boolean,
  },
  components: {
    TournamentTeamOverview,
    // Multiselect,
  },
  // data () {
  //   return {
  //     teams: this.tournament.teams.map(team => {
  //       team = _.cloneDeep(team)
  //       team.policy = policies.teamTournamentPolicy(this.tournament, team)
  //       return team
  //     })
  //   }
  // },
  computed: {
    teams () {
      return this.tournament.teams.map(team => {
        team = _.clone(team)
        team.policy = policies.teamTournamentPolicy(this.tournament, team)
        return team
      })
    },
    // teams () {
    //   for(const team of this.tournament.teams) {
    //     team.policy = policies.teamTournamentPolicy(this.tournament, team)
    //   }
    //   return this.tournament.teams
    // },
    // ...mapGetters(['userList']),
  },
  methods: {
    join (team) {
      team.members.push(this.currentUser)
      this.$store.dispatch('UPDATE_TOURNAMENT_LINEUP', [this.tournament, team])
    },
    leave (team) {
      const idx = team.members.findIndex(m => m.id === this.currentUser.id)
      team.members.splice(idx, 1)
      this.$store.dispatch('UPDATE_TOURNAMENT_LINEUP', [this.tournament, team])
    },
    addMember (team, member) {
      const newTeam = _.cloneDeep(team)
      newTeam.members.push(member)
      this.$store.dispatch('UPDATE_TOURNAMENT_LINEUP', [this.tournament, newTeam])
    },
    removeMember (team, member) {
      const newTeam = _.cloneDeep(team)
      const idx = newTeam.members.findIndex(m => m.id === member.id)
      newTeam.members.splice(idx, 1)
      this.$store.dispatch('UPDATE_TOURNAMENT_LINEUP', [this.tournament, newTeam])
    },
  },
}
</script>
