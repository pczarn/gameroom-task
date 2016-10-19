<template>
<div class="match">
  <div v-if="match && match.game && teams">
    Match owned by {{ match.owner.name }} <br>
    Game {{ match.game.name }}
    <div class="row">
      <span v-if="match.played_at">
        Played at <time :datetime="match.played_at">{{ playedAtFormatted }}</time>
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
      <span class="left-col">{{ match.scoreOne }}</span>
      <span class="middle-col">:</span>
      <span class="right-col">{{ match.scoreTwo }}</span>
    </div>
    <div class="row">
      <team-member-list :member_ids="teams[0].member_ids"
                        class="left-col">
      </team-member-list>
      <span class="middle-col">:</span>
      <team-member-list :member_ids="teams[1].member_ids"
                        class="right-col">
      </team-member-list>
    </div>

    <match-form :match="newMatch"
                button="Update the match"
                @submit="update()"
                v-if="editable">
    </match-form>
  </div>

  <button v-if="editable" @click="remove()">Remove</button>

  <a href="#" @click="goBack()">Go back</a>
</div>
</template>

<script>
import Vue from 'vue'
import { mapGetters } from 'vuex'
import moment from 'moment'
import TeamMemberList from './TeamMemberList'
import MatchForm from './MatchForm'

export default {
  name: 'Match',
  data () {
    return {
      newMatch: { owner: {} },
    }
  },
  components: {
    TeamMemberList,
    MatchForm,
  },
  computed: {
    scoreOne () {
      return this.match.team_one_score || '—'
    },
    scoreTwo () {
      return this.match.team_two_score || '—'
    },
    id () {
      return parseInt(this.$route.params.id)
    },
    match () {
      return this.matchMap.get(this.id)
    },
    playedAtFormatted () {
      return moment(this.match.played_at).format('YYYY-MM-DD HH:MM')
    },
    teams () {
      let { teamOne, teamTwo } = this.match
      return teamOne && teamTwo ? [teamOne, teamTwo] : false
    },
    editable () {
      return this.match && this.match.editable
    },
    ...mapGetters(['matchList', 'matchMap', 'teamList', 'gameList', 'currentUser']),
  },
  methods: {
    goBack () {
      this.$router.go(-1)
    },
    update () {
      this.$store.dispatch('UPDATE_MATCH', this.newMatch)
    },
    async remove () {
      await this.$store.dispatch('DESTROY_MATCH', this.match)
      this.$router.push('/matches')
    },
  },
  watch: {
    match (newValue) {
      this.newMatch = Vue.util.extend({}, newValue)
      if(newValue) {
        this.newMatch.id = newValue.id
      }
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
