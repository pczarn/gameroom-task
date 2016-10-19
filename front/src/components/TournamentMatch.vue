<template>
<div class="match">
  <div class="row">
    <span v-if="played_at">
      Played at <time :datetime="played_at">{{ playedAtFormatted }}</time>
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
</div>
</template>

<script>
import moment from 'moment'
import Team from './Team'

export default {
  data () {
    return {
      editable: false,
    }
  },
  components: {
    Team,
  },
  props: {
    id: Number,
    played_at: String,
    teamOne: Object,
    teamTwo: Object,
    team_one_score: Number,
    team_two_score: Number,
  },
  computed: {
    scoreOne () {
      return this.team_one_score || "—"
    },
    scoreTwo () {
      return this.team_two_score || "—"
    },
    playedAtFormatted () {
      return moment(this.played_at).format('YYYY-MM-DD HH:MM')
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
