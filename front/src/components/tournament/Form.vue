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
    <label for="startedAt">Starts at</label>
    <datepicker :date="startedAtTime" :option="pickerOption" @change="setStartedAt"></datepicker>
  </fieldset>
  <fieldset v-if="tournament.game">
    <legend>Choose game</legend>
    <p v-for="err in formErrors.game || []">{{ err }}</p>
    <select v-model="tournament.game.id" :class="{ err: !!formErrors.game }">
      <option v-for="game in gameList" :value="game.id">{{ game.name }}</option>
    </select>
  </fieldset>
  <p v-for="err in formErrors.name || []">{{ err }}</p>
  <fieldset :class="{ err: !!formErrors.name }">
    <legend>Choose teams</legend>
    <ul>
      <li v-for="(team, idx) in tournament.teams">
        Team <input type="text" v-model="team.name" :disabled="teamExists[idx]">
        <button type="button" @click.prevent="removeTeam(team)">X</button>
        <div v-for="member in team.members">
          {{ member.name }}
          <button type="button" @click.prevent="removeMember(team, member)">X</button>
        </div>
        <multiselect :options="potentialPlayers"
                     :searchable="true"
                     label="name"
                     placeholder="Pick a member"
                     @input="selectMemberInTeam(team, $event)"
                     :reset-after="true"
        >
        </multiselect>
      </li>
    </ul>

    <div v-if="!tournament.status || tournament.status === 'open'">
      Add a team
      <br>
      Choose team:
      <select @input="setNewTeam" class="right-col">
        <option disabled selected="!newTeamId" value> -- select a team -- </option>
        <option v-for="team in potentialTeams" :value="team.id" :selected="team.id === newTeamId">
          {{ team.name }}
        </option>
      </select>
      <br>
      Team <input type="text" v-model="newTeam.name" :disabled="!!newTeamId">
      <div v-for="member in newTeam.members">
        {{ member.name }}
        <button type="button" @click.prevent="removeMember(newTeam, member)">X</button>
      </div>
      <multiselect :options="potentialPlayersWithNewTeam"
                   :searchable="true"
                   label="name"
                   placeholder="Pick a member"
                   @input="selectMemberInTeam(newTeam, $event)"
                   :reset-after="true"
      >
      </multiselect>
      <button type="button" @click="addNewTeam">Add team</button>
    </div>
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
      tournament: {
        teams: [],
        game: {},
        startedAt: '',
      },
      newTeam: {
        name: '',
        members: [],
      },
      pickerOption,
    }
  },
  computed: {
    playerIds () {
      const teamMemberIds = this.tournament.teams.map(t => t.members.map(m => m.id))
      return new Set([].concat.apply([], teamMemberIds))
    },
    playerIdsIncludingNewTeam () {
      return new Set([...this.playerIds, this.newTeam.members.map(m => m.id)])
    },
    potentialPlayers () {
      return this.userList.filter(user => !this.playerIds.has(user.id))
    },
    potentialPlayersWithNewTeam () {
      return this.userList.filter(user => !this.playerIdsIncludingNewTeam.has(user.id))
    },
    startedAtTime () {
      return { time: this.tournament.startedAt }
    },
    teamExists () {
      return this.tournament.teams.map(team => this.getTeamByMembers(team.members) !== undefined)
    },
    newTeamId () {
      const team = this.getTeamByMembers(this.newTeam.members)
      if(team) return team.id
    },
    potentialTeams () {
      const memberNotInTournament = member => !this.playerIds.has(member.id)
      return this.teamList.filter(team => team.members.every(memberNotInTournament))
    },
    ...mapGetters([
      'userList',
      'gameList',
      'currentTournament',
      'teamByMemberIdsMap',
      'teamList',
      'teamMap',
      'formErrors',
    ]),
  },

  methods: {
    setNewTeam (event) {
      const teamId = parseInt(event.target.value)
      this.newTeam = _.cloneDeep(this.teamMap.get(teamId))
    },
    addNewTeam () {
      this.tournament.teams.push(this.newTeam)
      this.newTeam = this.$options.data().newTeam
    },
    getTeamByMembers (members) {
      const memberIds = members.map(m => m.id).sort().toString()
      return this.teamByMemberIdsMap.get(memberIds)
    },
    setTeam(idx, event) {
      const teamId = parseInt(event.target.value)
      const team = _.cloneDeep(this.teamMap.get(teamId))
      this.tournament.teams.splice(idx, 1, team)
    },
    selectMemberInTeam (team, member) {
      if(member) {
        const previousTeamMembers = _.clone(team.members)
        team.members.push(member)
        this.refreshTeam(previousTeamMembers, team)
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
      const previousTeamMembers = _.clone(team.members)
      const memberIdx = team.members.findIndex(m => m.id === member.id)
      team.members.splice(memberIdx, 1)
      this.refreshTeam(previousTeamMembers, team)
    },
    refreshTeam (previousTeamMembers, newTeam) {
      const reusedTeam = this.getTeamByMembers(newTeam.members)
      if(reusedTeam) {
        newTeam.name = reusedTeam.name
      } else {
        const previousTeam = this.getTeamByMembers(previousTeamMembers)
        if(previousTeam && newTeam.name === previousTeam.name) {
          newTeam.name = ''
        }
      }
    },
    setStartedAt (datetime) {
      this.tournament.startedAt = datetime
    },
  },
}
</script>

<style scoped>
.err {
  border-color: red;
}
</style>
