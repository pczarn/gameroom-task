<template>
<div>
  Match owned by {{ match.owner.name }} <br>
  Game {{ match.game.name }}
  <div class="row">
    <span v-if="match.playedAt">
      Played at <time :datetime="match.playedAt">{{ playedAtFormatted }}</time>
    </span>
    <span v-else>
      Played at an unknown time
    </span>
  </div>
  <div class="row">
    <strong class="left-col">{{ teams[0].name }}</strong>
    <span class="middle-col">vs</span>
    <strong class="right-col">{{ teams[1].name }}</strong>
  </div>
  <div class="row">
    <span class="left-col">{{ scoreOne }}</span>
    <span class="middle-col">:</span>
    <span class="right-col">{{ scoreTwo }}</span>
  </div>
  <div class="row">
    <team-member-list :members="teams[0].members"
                      class="left-col">
    </team-member-list>
    <span class="middle-col"></span>
    <team-member-list :members="teams[1].members"
                      class="right-col">
    </team-member-list>
  </div>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import moment from 'moment'
import { score } from 'src/util'
import TeamMemberList from 'src/components/team/MemberList'

export default {
  name: 'MatchDetails',
  components: {
    TeamMemberList,
  },
  computed: {
    scoreOne () {
      if(!this.match) {
        console.log(this)
        debugger;
      }
      return score(this.match.teamOneScore)
    },
    scoreTwo () {
      return score(this.match.teamTwoScore)
    },
    playedAtFormatted () {
      return moment(this.match.playedAt).format('YYYY-MM-DD HH:MM')
    },
    teams () {
      const { teamOne, teamTwo } = this.match
      return teamOne && teamTwo ? [teamOne, teamTwo] : false
    },
    ...mapGetters({
      match: 'currentMatch',
    }),
  },
}
</script>

<style lang="scss" scoped>
@import "./table";
</style>
