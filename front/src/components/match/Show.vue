<template>
<div class="match" v-if="match">
  <router-link v-if="!showDetails"
               :to="{ name: 'match details', params: { id: match.id } }">
    Details
  </router-link>
  <span v-else :class="{ bold: showDetails }" class="disabled">Details</span>

  <router-link v-if="canEdit && !showEdit"
               :to="{ name: 'match edit', params: { id: match.id } }">
    Edit
  </router-link>
  <span v-else :class="{ bold: showEdit }" class="disabled">Edit</span>

  <router-link v-if="canDestroy && !showDelete"
               :to="{ name: 'match delete', params: { id: match.id } }">
    Delete
  </router-link>
  <span v-else :class="{ bold: showDelete }" class="disabled">Delete</span>

  <router-view></router-view>

  <a href="#" @click="goBack()">Go back</a>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import moment from 'moment'
import policies from 'src/policies'
import { score } from 'src/util'
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
    canEdit () {
      return policies.friendlyMatchPolicy(this.match).update
    },
    canDestroy () {
      return policies.friendlyMatchPolicy(this.match).destroy
    },
    showDetails () {
      return this.$route.name === 'match details'
    },
    showEdit () {
      return this.$route.name === 'match edit'
    },
    showDelete () {
      return this.$route.name === 'match delete'
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
  },
}
</script>

<style lang="scss" scoped>
@import "./table";

span.disabled {
  color: gray;
}

span.bold {
  font-weight: bold;
  color: black !important;
}

.match {
 flex-direction: column;
}
</style>
