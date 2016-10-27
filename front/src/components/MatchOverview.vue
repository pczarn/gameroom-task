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
  <div class="row">
    <router-link :to="{ name: 'match', params: { id } }">See more</router-link>
  </div>
</div>
</template>

<script>
import moment from 'moment'
import Team from './Team'
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
    Team,
  },
  data () {
    return {
      editable: false,
    }
  },
  computed: {
    scoreOne () {
      return score(this.teamOneScore)
    },
    scoreTwo () {
      return score(this.teamTwoScore)
    },
    playedAtFormatted () {
      return moment(this.playedAt).format('YYYY-MM-DD HH:MM')
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
