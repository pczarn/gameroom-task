<template>
<div class="game-edit" v-if="game">
  <game-form :value="game"></game-form>
</div>
</template>

<script>
import GameForm from './GameForm'

export default {
  name: 'Game',
  components: {
    GameForm,
  },
  props: {
    game: Object,
  },
  computed: {
    editable () {
      return true
    },
  },
  methods: {
    async remove () {
      await this.$store.dispatch('DESTROY_GAME', this.game)
      this.$router.go(-1)
    },
  },
}
</script>
