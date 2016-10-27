<template>
<div class="team">
  <strong>{{name}}</strong>
  <team-member-list :members="members" :editable="true" @remove="remove">
  </team-member-list>
  <router-link :to="{ name: 'team', params: { id } }">See more</router-link>
  <multiselect v-if="tournament.policy.update && !full"
               :options="potentialPlayers"
               :searchable="true"
               label="name"
               key="name"
               placeholder="Pick a member"
               @select="selectMember">
  </multiselect>
  <button v-if="policy.join" @click.prevent="$emit('join')">Join</button>
  <button v-if="policy.leave" @click.prevent="$emit('leave')">Leave</button>
</div>
</template>

<script>
import TeamMemberList from './TeamMemberList'
import Multiselect from 'vue-multiselect'
import { mapGetters } from 'vuex'

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
    selectMember(member) {
      this.$emit('add-member', member)
    },
    remove(member) {
      this.$emit('remove-member', member)
    },
  },
}
</script>

<style scoped>
h1 {
  color: #42b983;
}
</style>
