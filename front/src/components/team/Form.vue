<template>
  <div>
    <form @submit.prevent="submit">
      <fieldset class="row">
        <legend>Name</legend>
        <input type="text" name="name" v-model="team.name">
      </fieldset>

      <fieldset v-if="create" class="row">
        <legend>Members</legend>
        <ul>
          <li v-for="member in team.members">
            {{ member.name }}
            <button @click.prevent="remove(member)">X</button>
          </li>
        </ul>
        <multiselect :options="potentialPlayers"
                     :searchable="true"
                     label="name"
                     key="name"
                     placeholder="Pick a member"
                     @select="selectMember"
                     :reset-after="true">
        </multiselect>
      </fieldset>

      <button type="submit">{{ buttonText }}</button>
    </form>
  </div>
</template>

<script>
import _ from 'lodash'
import Multiselect from 'vue-multiselect'
import { mapGetters } from 'vuex'

export default {
  name: 'TeamForm',
  components: {
    Multiselect,
  },
  data () {
    const blankTeam = { name: '', members: [] }
    return {
      blankTeam,
      team: _.cloneDeep(this.currentTeam || blankTeam),
    }
  },
  computed: {
    potentialPlayers () {
      const selected = this.team.members.map(m => m.id)
      return this.userList.filter(user => !selected.includes(user.id))
    },
    ...mapGetters(['currentTeam', 'userList']),
  },
  methods: {
    selectMember (member) {
      this.team.members.push(member)
    },
    remove (member) {
      const idx = this.team.members.findIndex(m => m.id === member.id)
      this.team.members.splice(idx, 1)
    },
  },
}
</script>
