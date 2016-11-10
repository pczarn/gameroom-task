<template>
<div>
  <form @submit.prevent="prepareAndSubmit" v-if="match && match.teamOne && match.teamTwo">
    <fieldset class="row">
      <legend>Choose game</legend>
      <select v-model="match.game.id">
        <option v-for="game in gameList" :value="game.id">{{ game.name }}</option>
      </select>
    </fieldset>

    <fieldset class="row">
      <label for="playedAt">Played at</label>
      <datepicker :date="playedAtTime" :option="pickerOption" @change="setPlayedAt"></datepicker>
    </fieldset>

    <fieldset class="row">
      <select :value="teamOneId" @input="setTeamOne" class="left-col">
        <option disabled :selected="!teamOneId" value> -- select a team -- </option>
        <option v-for="team in teamList" :value="team.id" :selected="team.id === teamOneId">
          {{ team.name }}
        </option>
      </select>
      <span class="middle-col">vs</span>
      <select :value="teamTwoId" @input="setTeamTwo" class="right-col">
        <option disabled selected="!teamTwoId" value> -- select a team -- </option>
        <option v-for="team in teamList" :value="team.id" :selected="team.id === teamTwoId">
          {{ team.name }}
        </option>
      </select>
    </fieldset>

    <fieldset class="row">
      <input type="text" v-model="match.teamOne.name" :disabled="!!teamOneId" class="left-col">
      <span class="middle-col">vs</span>
      <input type="text" v-model="match.teamTwo.name" :disabled="!!teamTwoId" class="right-col">
    </fieldset>

    <fieldset class="row scores">
      <div class="left-col">
        <input type="number" v-model="match.teamOneScore">
      </div>
      <span class="middle-col">:</span>
      <div class="right-col">
        <input type="number" v-model="match.teamTwoScore">
      </div>
    </fieldset>

    <fieldset class="row">
      <div class="left-col">
        <ul>
          <li v-for="member in match.teamOne.members">
            {{ member.name }}
            <button @click.prevent="remove('teamOne', member)">X</button>
          </li>
        </ul>
        <multiselect :options="potentialPlayers"
                     :searchable="true"
                     label="name"
                     key="name"
                     placeholder="Pick a member"
                     @select="selectMemberOfTeamOne"
                     :reset-after="true"
        >
        </multiselect>
      </div>
      <span class="middle-col"></span>
      <div class="right-col">
        <ul>
          <li v-for="member in match.teamTwo.members">
            {{ member.name }}
            <button @click.prevent="remove('teamTwo', member)">X</button>
          </li>
        </ul>
        <multiselect :options="potentialPlayers"
                     :searchable="true"
                     label="name"
                     key="name"
                     placeholder="Pick a member"
                     @select="selectMemberOfTeamTwo"
                     :reset-after="true"
        >
        </multiselect>
      </div>
    </fieldset>

    <button type="submit">{{ buttonText }}</button>
  </form>
</div>
</template>

<script>
import _ from 'lodash'
import { mapGetters } from 'vuex'
import Multiselect from 'vue-multiselect'
import Datepicker from 'vue-datepicker'
import { pickerOption } from 'src/util'

export default {
  components: {
    Multiselect,
    Datepicker,
  },

  data () {
    return {
      match: {
        teamOne: { members: [] },
        teamTwo: { members: [] },
        game: {},
        playedAt: '',
      },
      teamOneName: '',
      teamTwoName: '',
      playedAtTime: {
        time: '',
      },
      pickerOption,
    }
  },
  computed: {
    potentialPlayers () {
      if(this.match.teamOne.members && this.match.teamTwo.members) {
        const selected = (this.match.teamOne.members.concat(this.match.teamTwo.members)).map(m => m.id)
        return this.userList.filter(user => !selected.includes(user.id))
      } else {
        return this.userList
      }
    },
    playedAtTime () {
      return { time: this.match.playedAt }
    },
    teamOneId () {
      const team = this.getTeamByMembers(this.match.teamOne.members)
      if(team) return team.id

    },
    teamTwoId () {
      const team = this.getTeamByMembers(this.match.teamTwo.members)
      if(team) return team.id
    },
    ...mapGetters([
      'currentMatch',
      'teamList',
      'teamMap',
      'teamByMemberIdsMap',
      'gameList',
      'userList',
    ]),
  },

  methods: {
    remove (whichTeam, member) {
      const previousTeamMembers = _.clone(this.match[whichTeam].members)
      const newTeam = this.match[whichTeam]
      const memberIdx = newTeam.members.findIndex(m => m.id === member.id)
      newTeam.members.splice(memberIdx, 1)
      this.match[whichTeam] = newTeam
      this.refreshTeam(previousTeamMembers, newTeam)
    },
    setTeamOne (event) {
      const teamId = parseInt(event.target.value)
      const team = _.cloneDeep(this.teamMap.get(teamId))
      this.match.teamOne = team
    },
    setTeamTwo (event) {
      const teamId = parseInt(event.target.value)
      const team = _.cloneDeep(this.teamMap.get(teamId))
      this.match.teamTwo = team
    },
    selectMemberOfTeamOne (member) {
      const previousTeamMembers = _.clone(this.match.teamOne.members)
      this.match.teamOne.members.push(member)
      this.refreshTeam(previousTeamMembers, this.match.teamOne)
    },
    selectMemberOfTeamTwo (member) {
      const previousTeamMembers = _.clone(this.match.teamTwo.members)
      this.match.teamTwo.members.push(member)
      this.refreshTeam(previousTeamMembers, this.match.teamTwo)
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
    prepareAndSubmit () {
      this.submit()
    },
    setPlayedAt (datetime) {
      this.match.playedAt = datetime
    },
    getTeamByMembers (members) {
      const memberIds = members.map(m => m.id).sort().toString()
      return this.teamByMemberIdsMap.get(memberIds)
    },
  },
}
</script>

<style lang="scss" scoped>
@import "./table";

.scores input {
  width: 60px;
}
</style>
