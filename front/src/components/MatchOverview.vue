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
      <strong class="left-col">{{ team_one.name }}</strong>
      <span class="middle-col">vs</span>
      <strong class="right-col">{{ team_two.name }}</strong>
    </div>
    <div class="row">
      <span class="left-col">{{ scoreOne }}</span>
      <span class="middle-col">:</span>
      <span class="right-col">{{ scoreTwo }}</span>
    </div>
    <div class="row">
      <router-link :to="`/matches/${id}`">See more</router-link>
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
      team_one: Object,
      team_two: Object,
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
