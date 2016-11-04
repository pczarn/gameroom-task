<template>
<match-overview v-bind="match">
  <form v-if="editable" @submit.prevent="update">
    <fieldset class="row">
      <label for="playedAt">Played at</label>
      <input type="datetime-local" name="playedAt" v-model="form.playedAtLocal">
    </fieldset>

    <fieldset class="row scores">
      <div class="left-col">
        <input type="number" v-model="form.teamOneScore">
      </div>
      <span class="middle-col">:</span>
      <div class="right-col">
        <input type="number" v-model="form.teamTwoScore">
      </div>
    </fieldset>

    <button type="submit">Update</button>
  </form>
</match-overview>
</template>

<script>
import { mapGetters } from 'vuex'
import moment from 'moment'
import policies from 'src/policies'
import MatchOverview from 'src/components/match/Overview'
import * as action from 'src/store/action_types'

export default {
  props: {
    match: Object,
  },
  components: {
    MatchOverview,
  },
  data () {
    const playedAtLocal = moment(this.match.playedAt).toISOString().replace('Z', '')
    return {
      form: {
        playedAt: null,
        playedAtLocal,
        teamOneScore: this.match.teamOneScore,
        teamTwoScore: this.match.teamTwoScore,
      },
    }
  },
  computed: {
    editable () {
      return policies.tournamentMatchPolicy(this.tournament, this.match).update
    },
    ...mapGetters({
      tournament: 'currentTournament',
    }),
  },
  methods: {
    update () {
      this.form.playedAt = moment(this.form.playedAtLocal).toISOString()
      this.form.id = this.match.id
      this.$store.dispatch(action.UPDATE_TOURNAMENT_MATCH, [this.tournament, this.form])
    },
  },
}
</script>
