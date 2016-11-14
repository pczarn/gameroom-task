<template>
<div>
  Choose team:
  <select @input="setTeam" class="right-col">
    <option disabled selected="!teamId" value> -- select a team -- </option>
    <option v-for="team in teamList" :value="team.id" :selected="team.id === teamTwoId">
      {{ team.name }}
    </option>
  </select>
  Team <input type="text" v-model="newTeam.name" :disabled="teamExists">
  <button type="button" @click.prevent="removeTeam(team)">X</button>
  <div v-for="member in team.members">
    {{ member.name }}
    <button type="button" @click.prevent="removeMember(team, member)">X</button>
  </div>
  <multiselect :options="potentialPlayers"
               :searchable="true"
               label="name"
               placeholder="Pick a member"
               @input="selectMemberInTeam"
               :reset-after="true"
  >
  </multiselect>

  NOTHING
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
    teamExists () {

    },
    ...mapGetters(['teamList', 'userList']),
  },

  methods: {
    setTeam (event) {
      this.$emit('input', team)
    },
    selectMemberInTeam (team) {
      this.$emit('input', team)
    },
  },
}
</script>
