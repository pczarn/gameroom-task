<template>
<form @submit.prevent="$emit('submit')">
  <fieldset>
    <legend>Properties</legend>
    <template v-for="attrs in fields">
      <label :for="attrs.name">{{ attrs.name }}</label>
      <input v-bind="attrs" v-model="new_tournament[attrs.name]">
      <br>
    </template>
  </fieldset>
  <fieldset>
    <legend>Choose game</legend>
    <select v-model="new_tournament.game_id">
      <option v-for="game in gameList" :value="game.id">{{ game.name }}</option>
    </select>
  </fieldset>
  <fieldset>
    <legend>Choose teams</legend>
    <select v-model="new_tournament.team_one_id">
      <option v-for="team in teamList" :value="team.id">{{ team.name }}</option>
    </select>
    <select v-model="new_tournament.team_two_id">
      <option v-for="team in teamList" :value="team.id">{{ team.name }}</option>
    </select>

    <ul>
      <li v-for="team in tournament.teams">
        Team {{ team.name }}
        <button @click="removeTeam(team)">Remove member</button>
        <div v-for="member in match.teamOne.members">
          {{ member.name }}
          <button @click="removeMember(team, member)">Remove member</button>
        </div>
        <multiselect :options="potentialPlayers"
                     :searchable="true"
                     label="name"
                     key="name"
                     placeholder="Pick a member"
                     @select="selectMemberInTeam(team)">
        </multiselect>
      </li>
    </ul>

    Add a team
    <multiselect :options="potentialTeams"
                 :searchable="true"
                 label="name"
                 key="name"
                 placeholder="Pick a team"
                 @select="selectTeam">
    </multiselect>
  </fieldset>
  <button type="submit">{{ buttonText }}</button>
</form>
</template>

<script>
import { mapGetters } from 'vuex'
import Multiselect from 'vue-multiselect'

export default {
  props: {
    tournament: Object,
    buttonText: String,
  },
  components: {
    Multiselect,
  },
  computed: {
    playerIds () {
      const teamMemberIds = this.tournament.teams.map(t => t.members.map(m => m.id))
      return [].concat.apply([], teamMemberIds)
    },
    potentialPlayers () {
      return this.userList.filter(user => !this.playerIds.has(user.id))
    },
    potentialTeams () {
      const memberNotInTournament = member => !this.playerIds.has(member.id)
      return this.teamList.filter(team => team.members.every(memberNotInTournament))
    },
    ...mapGetters(['tournamentMap', 'teamList', 'userList', 'currentUser', 'isAdmin']),
  },
  methods: {
    selectMemberInTeam (team) {
      return member => team.members.push(member)
    },
    selectTeam (team) {
      this.tournament.teams.push(team)
    },
    removeTeam (team) {
      let teamIdx = this.tournament.teams.findIndex(t => t.id === team.id)
      this.tournament.teams.splice(teamIdx, 1)
    },
    removeMember (team, member) {
      let memberIdx = team.members.findIndex(m => m.id === member.id)
      team.members.splice(memberIdx, 1)
    },
  },
}
</script>

<style scoped>
</style>
