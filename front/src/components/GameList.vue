<template>
<div id="games">
  <h1>Games</h1>

  <template v-if="isAdmin">
    <h2>Add a game</h2>
    <form @submit.prevent>
      <fieldset>
        <legend>Properties</legend>
        <template v-for="attrs in game_fields">
          <label :for="attrs.name">{{attrs.name}}</label>
          <input v-bind="attrs" v-model="new_game[attrs.name]">
        </template>
        <button type="submit" @click="create()">Add the game</button>
      </fieldset>
    </form>
  </template>

  <h2>Active games</h2>
  <ul>
    <li v-for="game in activeGames">
      <Game v-bind="game" :editable="isAdmin" @remove="destroy(game)">
      <button v-if="isAdmin" @click="archivize(game)">Archivize</button>
    </li>
  </ul>

  <h2>Archivized games</h2>
  <ul>
    <li v-for="game in archivizedGames">
      <Game v-bind="game" :editable="isAdmin" @remove="destroy(game)">
      <button v-if="isAdmin" v-on:click="activate(game)">Activate</button>
    </li>
  </ul>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import Game from './Game'

export default {
  data () {
    return {
      game_fields: [
        { name: 'name', type: 'text' },
        { name: 'image', type: 'file', accept: "image/*" },
      ],
      new_game: {},
    }
  },
  components: {
    Game
  },
  beforeMount() {
    this.$store.dispatch('GET_GAMES')
  },
  methods: {
    create() {
      this.$store.dispatch('CREATE_GAME', this.new_game)
        .then(_ => { this.new_game = {} })
    },
    destroy(game) {
      this.$store.dispatch('DESTROY_GAME', game)
    },
    archivize(game) {
      this.setArchivized(game, true)
    },
    activate(game) {
      this.setArchivized(game, false)
    },
    setArchivized(game, archivized) {
      this.$store.dispatch('UPDATE_GAME', { state_archivized: archivized })
    },
  },
  computed: {
    ...mapGetters(['isAdmin', 'activeGames', 'archivizedGames']),
  }
}
</script>

<style scoped>
</style>
