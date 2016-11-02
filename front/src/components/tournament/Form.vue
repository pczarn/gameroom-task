<template>
<form @submit.prevent="submit">
  <fieldset>
    <legend>Properties</legend>
    <template v-for="field in schema">
      <label :for="field.attrs.name">{{ field.label }}</label>
      <br>
      <input v-bind="field.attrs" v-model="tournamentClone[field.attrs.name]">
      <br>
    </template>
  </fieldset>
  <fieldset v-if="tournamentClone.game">
    <legend>Choose game</legend>
    <select v-model="tournamentClone.game.id">
      <option v-for="game in gameList" :value="game.id">{{ game.name }}</option>
    </select>
  </fieldset>
  <fieldset>
    <legend>Choose teams</legend>
    <ul>
      <li v-for="team in tournamentClone.teams">
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

    <select-team :tournament="tournamentClone" @input="addTeam">
    </select-team>
  </fieldset>
  <button type="submit">{{ buttonText }}</button>
</form>
</template>

<script>
import _ from 'lodash'
import { mapGetters } from 'vuex'
import Multiselect from 'vue-multiselect'
import SelectTeam from './SelectTeam'

export default {
  name: 'TournamentForm',
  props: {
    tournament: {
      type: Object,
      default () {
        return { teams: [], game: {} }
      },
    },
  },
  components: {
    Multiselect,
    SelectTeam,
  },
  data () {
    return {
      schema: [
        { attrs: { name: 'title', type: 'text' }, label: 'Title' },
        { attrs: { name: 'description', type: 'textarea' }, label: 'Description' },
        { attrs: { name: 'image', type: 'file', accept: "image/*" }, label: 'Image' },
        { attrs: { name: 'numberOfTeams', type: 'number' }, label: 'Number of teams' },
        { attrs: { name: 'number_of_members_per_team', type: 'num' }, label: 'Number of members per team' },
        { attrs: { name: 'startedAt', type: 'datetime-local' }, label: 'Starts at' },
      ],
      tournamentClone: _.cloneDeep(this.tournament),
    }
  },
  computed: {
    playerIds () {
      const teamMemberIds = this.tournamentClone.teams.map(t => t.members.map(m => m.id))
      return new Set([].concat.apply([], teamMemberIds))
    },
    potentialPlayers () {
      return this.userList.filter(user => !this.playerIds.has(user.id))
    },
    ...mapGetters(['userList', 'gameList']),
  },
  methods: {
    selectMemberInTeam (team, member) {
      if(member) {
        team.members.push(member)
      }
    },
    addTeam (team) {
      if(team) {
        this.tournamentClone.teams.push(team)
      }
    },
    removeTeam (team) {
      const teamIdx = this.tournamentClone.teams.findIndex(t => t.id === team.id)
      this.tournamentClone.teams.splice(teamIdx, 1)
    },
    removeMember (team, member) {
      const memberIdx = team.members.findIndex(m => m.id === member.id)
      team.members.splice(memberIdx, 1)
    },
  },
}
</script>
