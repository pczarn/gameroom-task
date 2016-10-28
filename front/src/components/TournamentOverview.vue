<template>
<div class="tournament-overview">
  <h2>Tournament {{ title }}</h2>
  <span v-if="isReadyToStart">
    Ready to start. Waiting for teams.
  </span>
  <span v-else>
    <span v-if="startedAt">
      <span v-if="futureStartDate">Will start on</span>
      <span v-else>Started</span>

      <timeago v-if="!futureStartDate" :since="startedAt"></timeago>
      <span v-if="futureStartDate">{{ futureStartDate }}</span>
    </span>
    <span v-else>
      Without start date
    </span>
  </span>

  <br>

  <TournamentStatus v-if="isOpen" :status="teamsInfo" label="Teams"></TournamentStatus>
  <TournamentStatus v-if="isStarted" :status="roundsInfo" label="Rounds"></TournamentStatus>
  <span v-if="isEnded">Team {{ winningTeam && winningTeam.name }} won</span>

  <router-link :to="{ name: 'tournament', params: { id } }">See more</router-link>
</div>
</template>

<script>
import moment from 'moment'
import TournamentStatus from './TournamentStatus'

export default {
  name: 'TournamentOverview',
  props: {
    id: Number,
    title: String,
    startedAt: String,
    status: String,
    teams: Array,
    rounds: Array,
    numberOfTeams: Number,
  },
  components: {
    TournamentStatus,
  },
  computed: {
    editable () {
      return this.$store.getters.isAdmin
    },
    isOpen () {
      return this.status == 'open'
    },
    isStarted () {
      return this.status == 'started'
    },
    isEnded () {
      return this.status == 'ended'
    },
    isReadyToStart () {
      return this.isOpen && this.startedAt && new Date(this.startedAt) < new Date()
    },
    startDateInPast () {
      return new Date(this.startedAt) < new Date()
    },
    futureStartDate () {
      if(new Date(this.startedAt) > new Date()) {
        return moment(this.startedAt).format('YYYY-MM-DD HH:MM')
      }
    },
    teamsInfo () {
      return {
        size: this.numberOfTeams,
        slots: this.teams.map(tt => [tt.members.length, tt.numberOfSlots]),
      }
    },
    roundsInfo () {
      return {
        size: this.rounds.length,
        slots: this.rounds.map((round, idx) => {
          let numberOfMatches = Math.pow(2, this.rounds.length - 1 - idx)
          return [round.length, numberOfMatches]
        }),
      }
    },
    winningTeam () {
      let lastRound = this.rounds[this.rounds.length - 1]
      if(lastRound) {
        let lastMatch = lastRound[0]
        return lastMatch.winner
      } else {
        return { name: '(unknown)' }
      }
    },
  },
}
</script>

<style scoped>
</style>
