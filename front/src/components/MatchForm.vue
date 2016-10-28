<template>
<div>
  <form @submit.prevent="submit" v-if="match && match.teamOne && match.teamTwo">
    <fieldset class="row">
      <legend>Choose game</legend>
      <select v-model="match.game.id">
        <option v-for="game in gameList" :value="game.id">{{ game.name }}</option>
      </select>
    </fieldset>

    <fieldset class="row">
      <label for="playedAt">Played at</label>
      <input type="datetime-local" name="playedAt" v-model="playedAtLocal">
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
import moment from 'moment'
import _ from 'lodash'

export default {
  props: {
    buttonText: String,
    clearOnSubmit: Boolean,
    value: {
      type: Object,
      default () {
        return { teamOne: { members: [] }, teamTwo: { members: [] }, game: {} }
      },
    },
  },
  components: {
    Multiselect,
  },
  data () {
    const match = _.cloneDeep(this.value)
    const playedAtLocal = moment(match.playedAt).toISOString().replace('Z', '')
    return { match, playedAtLocal, teamOneName: '', teamTwoName: '' }
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
    ...mapGetters(['teamList', 'teamMap', 'gameList', 'userList']),
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
      const id = parseInt(event.target.value)
      // this.match.teamOne.id = id
      const team = _.cloneDeep(this.teamMap.get(id))
      this.match.teamOne = team
    },
    setTeamTwo (event) {
      const id = parseInt(event.target.value)
      // this.match.teamTwo.id = id
      const team = _.cloneDeep(this.teamMap.get(id))
      this.match.teamTwo = team
    },
    submit () {
      this.match.playedAt = moment(this.playedAtLocal).toISOString()
      this.$emit('submit', this.match)
      if(this.clearOnSubmit) {
        this.match = {}
      }
    },
  },
}
</script>

<style scoped>
.row {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.left-col {
  width: 50%;
  flex: 0 1 auto;
  text-align: right;
}

.right-col {
  width: 50%;
  flex: 0 1 auto;
  text-align: left;
}

.middle-col {
  padding: 0 5px;
}

.scores input {
  width: 60px;
}
</style>
