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
  <slot>
    <div class="row">
      <router-link :to="{ name: 'match', params: { id } }">See more</router-link>
    </div>
  </slot>
</div>
</template>

<script>
import moment from 'moment'
import Team from 'src/components/team/Show'
import { score } from 'src/util'

export default {
  name: 'MatchOverview',
  components: {
    Team,
  },

  props: {
    id: Number,
    playedAt: String,
    createdAt: String,
    teamOne: Object,
    teamTwo: Object,
    teamOneScore: Number,
    teamTwoScore: Number,
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

<style lang="scss" scoped>
@import "./table";
</style>
