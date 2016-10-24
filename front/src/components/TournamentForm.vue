<template>
<form @submit.prevent="$emit('submit')">
  <fieldset>
    <legend>Properties</legend>
    <template v-for="attrs in fields">
      <label :for="attrs.name">{{ attrs.name }}</label>
      <input v-bind="attrs" v-model="tournament[attrs.name]">
      <br>
    </template>
  </fieldset>
  <fieldset>
    <legend>Choose game</legend>
    <select v-model="tournament.game_id">
      <option v-for="game in gameList" :value="game.id">{{ game.name }}</option>
    </select>
  </fieldset>
  <fieldset>
    <legend>Choose teams</legend>
    <ul>
      <li v-for="team in tournament.teams">
        Team {{ team.name }}
        <button @click.prevent="removeTeam(team)">Remove team</button>
        <div v-for="member in team.members">
          {{ member.name }}
          <button @click.prevent="removeMember(team, member)">Remove member</button>
        </div>
        <multiselect :options="potentialPlayers"
                     :searchable="true"
                     label="name"
                     track-by="name"
                     placeholder="Pick a member"
                     @input="selectMemberInTeam(team, $event)">
        </multiselect>
      </li>
    </ul>

    Add a team
    <multiselect :options="potentialTeams"
                 :searchable="true"
                 label="name"
                 track-by="name"
                 placeholder="Pick a team"
                 @input="selectTeam">
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
  data () {
    return {
      fields: [
        { name: 'title', type: 'text' },
        { name: 'description', type: 'textarea' },
        { name: 'image', type: 'file', accept: "image/*" },
        { name: 'number_of_teams', type: 'number' },
        { name: 'number_of_members_per_team', type: 'num' },
        { name: 'started_at', type: 'datetime' },
      ],
    }
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
    ...mapGetters(['tournamentMap', 'teamList', 'userList', 'gameList', 'currentUser', 'isAdmin']),
  },
  methods: {
    selectMemberInTeam (team, member) {
      if(member) {
        team.members.push(member)
      }
    },
    selectTeam (team) {
      if(team) {
        this.tournament.teams.push(team)
      }
    },
    removeTeam (team) {
      console.log(this.tournament, this.tournament.teams.length)
      let teamIdx = this.tournament.teams.findIndex(t => t.id === team.id)
      console.log(teamIdx)
      this.tournament.teams.splice(teamIdx, 1)
      console.log(this.tournament.teams.length)
      this.tournament = this.tournament
    },
    removeMember (team, member) {
      let memberIdx = team.members.findIndex(m => m.id === member.id)
      team.members.splice(memberIdx, 1)
    },
  },
}
</script>
