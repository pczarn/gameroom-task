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
      <select :value="match.teamOne.id" @input="setTeamOne" class="left-col">
        <option v-for="team in teamList" :value="team.id">{{ team.name }}</option>
      </select>
      <span class="middle-col">vs</span>
      <select :value="match.teamTwo.id" @input="setTeamTwo" class="right-col">
        <option v-for="team in teamList" :value="team.id">{{ team.name }}</option>
      </select>
    </fieldset>

    <fieldset class="row">
      <input type="text" v-model="match.teamOne.name" class="left-col">
      <span class="middle-col">vs</span>
      <input type="text" v-model="match.teamTwo.name" class="right-col">
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
import { mapGetters } from 'vuex'
import Multiselect from 'vue-multiselect'
import Datepicker from 'vue-datepicker'
import _ from 'lodash'
import { pickerOption } from 'src/util'

export default {
  components: {
    Multiselect,
    Datepicker,
  },
  data () {
    return {
      match: { teamOne: { members: [] }, teamTwo: { members: [] }, game: {} },
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
    ...mapGetters(['currentMatch', 'teamList', 'teamMap', 'gameList', 'userList']),
  },
  methods: {
    remove (whichTeam, member) {
      const newTeam = this.match[whichTeam]
      const memberIdx = newTeam.members.findIndex(m => m.id === member.id)
      newTeam.members.splice(memberIdx, 1)
      this.match[whichTeam] = newTeam
    },
    selectMemberOfTeamOne (member) {
      this.match.teamOne.members.push(member)
    },
    selectMemberOfTeamTwo (member) {
      this.match.teamTwo.members.push(member)
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
    prepareAndSubmit () {
      this.submit()
    },
    setPlayedAt (datetime) {
      this.match.playedAt = datetime
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
