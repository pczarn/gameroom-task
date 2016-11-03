<template>
<div class="match">
  <div class="row">
    <span v-if="playedAt">
      Played at <time :datetime="playedAt">{{ playedAtFormatted }}</time>
    </span>
    <span v-else>
      Played at an unknown time
    </span>
  </div>
  <div class="row">
    <strong class="left-col">{{ teamOne.name }}</strong>
    <span class="middle-col">vs</span>
    <strong class="right-col">{{ teamTwo.name }}</strong>
  </div>
  <div class="row">
    <span class="left-col">{{ scoreOne }}</span>
    <span class="middle-col">:</span>
    <span class="right-col">{{ scoreTwo }}</span>
  </div>

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
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import moment from 'moment'
import policies from 'src/policies'
// import Team from '../Team'
import { score } from 'src/util'

export default {
  props: {
    id: Number,
    playedAt: String,
    teamOne: Object,
    teamTwo: Object,
    teamOneScore: Number,
    teamTwoScore: Number,
  },
  components: {
    // Team,
  },
  data () {
    const playedAtLocal = moment(this.playedAt).toISOString().replace('Z', '')
    return {
      form: {
        playedAt: null,
        playedAtLocal,
        teamOneScore: this.teamOneScore,
        teamTwoScore: this.teamTwoScore,
      },
    }
  },
  computed: {
    editable () {
      return policies.tournamentMatchPolicy(this.tournament, this).update
    },
    scoreOne () {
      return score(this.teamOneScore)
    },
    scoreTwo () {
      return score(this.teamTwoScore)
    },
    playedAtFormatted () {
      return moment(this.playedAt).format('YYYY-MM-DD HH:MM')
    },
    ...mapGetters({
      tournament: 'currentTournament',
    }),
  },
  methods: {
    update () {
      this.form.playedAt = moment(this.form.playedAtLocal).toISOString()
      this.form.id = this.id
      this.$store.dispatch('UPDATE_TOURNAMENT_MATCH', [this.tournament, this.form])
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
</style>
