<template>
<match-overview v-bind="match">
  <form v-if="editable" @submit.prevent="update">
    <fieldset class="row">
      <label for="playedAt">Played at</label>
      <datepicker :date="playedAtTime" :option="pickerOption" @change="setPlayedAt"></datepicker>
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
import policies from 'src/policies'
import MatchOverview from 'src/components/match/Overview'
import Datepicker from 'vue-datepicker'
import * as action from 'src/store/action_types'
import { pickerOption } from 'src/util'

export default {
  props: {
    match: Object,
  },
  components: {
    MatchOverview,
    Datepicker,
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
