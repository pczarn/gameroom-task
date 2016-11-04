<template>
<div class="team">
  <strong>{{ name }}</strong>
  <team-member-list :members="members" :editable="tournamentPolicy.update" @remove="removeMember">
  </team-member-list>
  <router-link :to="{ name: 'team', params: { id } }">See more</router-link>
  <multiselect v-if="tournamentPolicy.update && !full"
               :options="potentialPlayers"
               :searchable="true"
               label="name"
               key="name"
               placeholder="Pick a member"
               @select="selectMember"
               :reset-after="true"
  >
  </multiselect>
  <button v-if="policy.join" @click.prevent="join">Join</button>
  <button v-if="policy.leave" @click.prevent="leave">Leave</button>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import _ from 'lodash'
import Multiselect from 'vue-multiselect'
import TeamMemberList from 'src/components/team/MemberList'
import policies from 'src/policies'
import * as action from 'src/store/action_types'

export default {
  name: 'TournamentTeamOverview',
  props: {
    id: Number,
    name: String,
    members: Array,
    numberOfSlots: Number,
    policy: Object,
    tournament: Object,
  },
  components: {
    TeamMemberList,
    Multiselect,
  },
  computed: {
    tournamentPolicy () {
      return policies.tournamentPolicy(this.tournament).update
    },
    policy () {
      return policies.teamTournamentPolicy(this.tournament, this)
    },
    full () {
      return this.numberOfSlots && this.members.length >= this.numberOfSlots
    },
    playerIds () {
      const teamMemberIds = this.tournament.teams.map(t => t.members.map(m => m.id))
      return new Set([].concat.apply([], teamMemberIds))
    },
    potentialPlayers () {
      return this.userList.filter(user => !this.playerIds.has(user.id))
    },
    ...mapGetters(['userList']),
  },
  methods: {
    cloneTeam () {
      return _.cloneDeep({
        id: this.id,
        name: this.name,
        members: this.members,
      })
    },
    join () {
      const team = this.cloneTeam()
      team.members.push(this.currentUser)
      this.$store.dispatch(action.UPDATE_TOURNAMENT_LINEUP, [this.tournament, team])
    },
    leave () {
      const team = this.cloneTeam()
      const idx = team.members.findIndex(m => m.id === this.currentUser.id)
      team.members.splice(idx, 1)
      this.$store.dispatch(action.UPDATE_TOURNAMENT_LINEUP, [this.tournament, team])
    },
    selectMember (member) {
      const team = this.cloneTeam()
      team.members.push(member)
      this.$store.dispatch(action.UPDATE_TOURNAMENT_LINEUP, [this.tournament, team])
    },
    removeMember (member) {
      const team = this.cloneTeam()
      const idx = team.members.findIndex(m => m.id === member.id)
      team.members.splice(idx, 1)
      this.$store.dispatch(action.UPDATE_TOURNAMENT_LINEUP, [this.tournament, team])
    },
  },
}
</script>
