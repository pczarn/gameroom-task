<template>
<div class="tournament-overview">
  <h2>Tournament {{ title }}</h2>
  <span v-if="isReadyToStart">
    Ready to start. Waiting for teams.
  </span>
  <span v-else>
    <span v-if="started_at">
      <span v-if="futureStartDate">Will start on</span>
      <span v-else>Started</span>

      <timeago v-if="!futureStartDate" :since="started_at"></timeago>
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

  <router-link append :to="''+id">See more</router-link>
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
    started_at: String,
    status: String,
    teams: Array,
    rounds: Array,
    number_of_teams: Number,
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
      return this.isOpen && this.started_at && new Date(this.started_at) < new Date()
    },
    startDateInPast () {
      return new Date(this.started_at) < new Date()
    },
    futureStartDate () {
      if(new Date(this.started_at) > new Date()) {
        return moment(this.started_at).format('YYYY-MM-DD HH:MM')
      }
    },
    teamsInfo () {
      return {
        size: this.number_of_teams,
        slots: this.teams.map(tt => [tt.number_of_members, tt.number_of_slots]),
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
        let winner = [lastMatch.team_one, lastMatch.team_two][lastMatch.winner]
        return winner
      } else {
        return { name: '(unknown)' }
      }
    },
    // startedAt () {
    //   if(this.started_at < new Date())
    // },

  },
}
</script>

<style scoped>
</style>
