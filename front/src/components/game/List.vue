<template>
<div id="games">
  <h1>Games</h1>

  <template v-if="isAdmin">
    <h2>Add a game</h2>
    <game-create></game-create>
  </template>

  <h2>Active games</h2>
  <ul>
    <li v-for="game in activeGames">
      <game-overview v-bind="game" :editable="isAdmin">
      </game-overview>
      <button v-if="isAdmin" @click="archivize(game)">Archivize</button>
    </li>
  </ul>

  <h2>Archivized games</h2>
  <ul>
    <li v-for="game in archivizedGames">
      <game-overview v-bind="game" :editable="isAdmin">
      </game-overview>
      <button v-if="isAdmin" v-on:click="activate(game)">Activate</button>
    </li>
  </ul>
</div>
</template>

<script>
import { mapGetters } from 'vuex'
import * as action from 'src/store/action_types'
import GameOverview from './Overview'
import GameCreate from './Create'

export default {
  name: 'GameList',
  components: {
    GameOverview,
    GameCreate,
  },
  computed: {
    ...mapGetters(['isAdmin', 'activeGames', 'archivizedGames']),
  },
  methods: {
    archivize (game) {
      this.setArchivized(game, true)
    },
    activate (game) {
      this.setArchivized(game, false)
    },
    setArchivized (game, archivized) {
      this.$store.dispatch(action.UPDATE_GAME, {
        id: game.id,
        state_archivized: archivized,
      })
    },
  },
}
</script>
