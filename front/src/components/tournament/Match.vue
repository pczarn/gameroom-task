<template>
<match-overview v-bind="match">
  <form v-if="editable" @submit.prevent="update">
    <p v-for="err in formErrors.played_at || []">{{ err }}</p>
    <fieldset class="row" :class="{ err: formErrors.played_at }">
      <label for="playedAt">Played at</label>
      <datepicker :date="playedAtTime" :option="pickerOption" @change="setPlayedAt"></datepicker>
    </fieldset>

    <p v-for="err in formErrors.team_one_score || []">{{ err }}</p>
    <p v-for="err in formErrors.team_two_score || []">{{ err }}</p>
    <fieldset class="row scores">
      <div class="left-col">
        <input type="number" v-model="form.teamOneScore" :class="{ err: formErrors.team_one_score }">
      </div>
      <span class="middle-col">:</span>
      <div class="right-col">
        <input type="number" v-model="form.teamTwoScore" :class="{ err: formErrors.team_two_score }">
      </div>
    </fieldset>

    <button type="submit">Update</button>
  </form>
</match-overview>
</template>

<script>
import { mapGetters } from 'vuex'
import policies from 'src/policies'
import MatchOverview from 'src/components/match/Overview'
import Datepicker from 'vue-datepicker'
import * as action from 'src/store/action_types'
import { pickerOption } from 'src/util'

export default {
  name: 'TournamentMatch',
  components: {
    MatchOverview,
    Datepicker,
  },

  props: {
    match: Object,
  },
  data () {
    return {
      form: {
        id: this.match.id,
        playedAt: null,
        teamOneScore: this.match.teamOneScore,
        teamTwoScore: this.match.teamTwoScore,
      },
      pickerOption,
    }
  },
  computed: {
    editable () {
      return policies.tournamentMatchPolicy(this.tournament, this.match).update
    },
    playedAtTime () {
      return { time: this.match.playedAt }
    },
    ...mapGetters({
      tournament: 'currentTournament',
      formErrors: 'formErrors',
    }),
  },

  methods: {
    update () {
      this.$store.dispatch(action.UPDATE_TOURNAMENT_MATCH, [this.tournament, this.form])
    },
    setPlayedAt (datetime) {
      this.form.playedAt = datetime
    },
  },
}
</script>
