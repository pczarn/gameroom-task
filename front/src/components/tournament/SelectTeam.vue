<template>
<div>
  Add a team
  <multiselect :options="potentialTeams"
               :searchable="true"
               label="name"
               placeholder="Pick a team"
               @input="select"
               :reset-after="true"
  >
  </multiselect>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import Multiselect from 'vue-multiselect'

export default {
  name: 'TournamentSelectTeam',
  components: {
    Multiselect,
  },

  props: {
    tournament: Object,
  },
  computed: {
    playerIds () {
      const teamMemberIds = this.tournament.teams.map(t => t.members.map(m => m.id))
      return new Set([].concat.apply([], teamMemberIds))
    },
    potentialPlayers () {
      return this.userList.filter(user => !this.playerIds.has(user.id))
    },
    potentialTeams () {
      const memberNotInTournament = member => !this.playerIds.has(member.id)
      return this.teamList.filter(team => team.members.every(memberNotInTournament))
    },
    ...mapGetters(['teamList', 'userList']),
  },

  methods: {
    select (team) {
      this.$emit('input', team)
    },
  },
}
</script>
