<template>
<form @submit.prevent="submit">
  <fieldset>
    <legend>Properties</legend>
    <template v-for="field in schema">
      <label :for="field.attrs.name">{{ field.label }}</label>
      <br>
      <input v-bind="field.attrs" v-model="tournament[field.attrs.name]">
      <br>
    </template>
    <label :for="startedAt">Starts at</label>
    <datepicker :date="startedAt" :option="pickerOption" @change="setStartedAt"></datepicker>
  </fieldset>
  <fieldset v-if="tournament.game">
    <legend>Choose game</legend>
    <select v-model="tournament.game.id">
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
                     @input="selectMemberInTeam(team, $event)"
                     :reset-after="true"
        >
        </multiselect>
      </li>
    </ul>

    <select-team :tournament="tournament" @input="addTeam">
    </select-team>
  </fieldset>
  <button type="submit">{{ buttonText }}</button>
</form>
</template>

<script>
import { mapGetters } from 'vuex'
import Multiselect from 'vue-multiselect'
import Datepicker from 'vue-datepicker'
import SelectTeam from './SelectTeam'
import { pickerOption } from 'src/util'

export default {
  name: 'TournamentForm',
  components: {
    Multiselect,
    Datepicker,
    SelectTeam,
  },
  data () {
    return {
      schema: [
        { attrs: { name: 'title', type: 'text' }, label: 'Title' },
        { attrs: { name: 'description', type: 'textarea' }, label: 'Description' },
        { attrs: { name: 'image', type: 'file', accept: "image/*" }, label: 'Image' },
        { attrs: { name: 'numberOfTeams', type: 'number' }, label: 'Number of teams' },
        { attrs: { name: 'numberOfMembersPerTeam', type: 'num' }, label: 'Number of members per team' },
      ],
      tournament: { teams: [], game: {} },
      pickerOption,
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
    startedAt () {
      return { time: this.tournament.startedAt || '' }
    },
    ...mapGetters(['userList', 'gameList', 'currentTournament']),
  },
  methods: {
    selectMemberInTeam (team, member) {
      if(member) {
        team.members.push(member)
      }
    },
    addTeam (team) {
      if(team) {
        this.tournament.teams.push(team)
      }
    },
    removeTeam (team) {
      const teamIdx = this.tournament.teams.findIndex(t => t.id === team.id)
      this.tournament.teams.splice(teamIdx, 1)
    },
    removeMember (team, member) {
      const memberIdx = team.members.findIndex(m => m.id === member.id)
      team.members.splice(memberIdx, 1)
    },
    setStartedAt (datetime) {
      this.tournament.startedAt = datetime
    },
  },
}
</script>
