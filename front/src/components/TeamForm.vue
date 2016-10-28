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
import Vue from 'vue'
import Multiselect from 'vue-multiselect'
import { mapGetters } from 'vuex'

export default {
  name: 'TeamForm',
  components: {
    Multiselect,
  },
  props: {
    value: {
      type: Object,
      default () {
        return {
          name: '',
          members: [],
        }
      },
    },
    buttonText: String,
    create: Boolean,
  },
  data () {
    return {
      team: Vue.util.extend({}, this.value),
    }
  },
  computed: {
    potentialPlayers () {
      const selected = this.team.members.map(m => m.id)
      return this.userList.filter(user => !selected.includes(user.id))
    },
    ...mapGetters(['userList']),
  },
  methods: {
    selectMember (member) {
      this.team.members.push(member)
    },
    remove (member) {
      const idx = this.team.members.findIndex(m => m.id === member.id)
      this.team.members.splice(idx, 1)
    },
    submit () {
      this.$emit('submit', this.team)
      if(this.create) {
        this.team = Vue.util.extend({}, this.value)
      }
    },
  },
}
</script>
