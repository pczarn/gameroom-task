<template>
<div class="match" v-if="match && teams">
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

    <match-edit :value="match" v-if="canEdit"></match-edit>
  </div>

  <button v-if="canDestroy" @click="remove()">Remove</button>

  <a href="#" @click="goBack()">Go back</a>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import moment from 'moment'
import policies from 'src/policies'
import { score } from 'src/util'
import * as action from 'src/store/action_types'
import TeamMemberList from 'src/components/team/MemberList'
import MatchEdit from './Edit'

export default {
  name: 'MatchShow',
  components: {
    TeamMemberList,
    MatchEdit,
  },
  computed: {
    scoreOne () {
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
    canEdit () {
      return policies.friendlyMatchPolicy(this.match).update
    },
    canDestroy () {
      return policies.friendlyMatchPolicy(this.match).destroy
    },
    ...mapGetters(['matchList', 'matchMap', 'teamList', 'gameList', 'currentUser']),
    ...mapGetters({
      match: 'currentMatch',
    }),
  },
  methods: {
    goBack () {
      this.$router.go(-1)
    },
    async remove () {
      await this.$store.dispatch(action.DESTROY_MATCH, this.match)
      this.$router.push('/matches')
    },
  },
}
</script>

<style scoped>
.match {
 /* display: flex;*/
 flex-direction: column;
}
.row {
  display: flex;
  flex-direction: row;
  align-items: center;
  /*flex: 2 2 auto;*/
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
