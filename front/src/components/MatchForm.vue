<template>
  <div>
    <form @submit.prevent="$emit('submit')">
      <fieldset class="row">
        <legend>Choose game</legend>
        <select v-model="match.game_id">
          <option v-for="game in gameList" :value="game.id">{{ game.name }}</option>
        </select>
      </fieldset>

      <fieldset class="row">
        <label for="played_at">Played at</label>
        <input type="datetime" name="played_at" v-model="match.played_at">
      </fieldset>

      <fieldset class="row">
        <select v-model="match.team_one_id" class="left-col">
          <option v-for="team in teamList" :value="team.id">{{ team.name }}</option>
        </select>
        <span class="middle-col">vs</span>
        <select v-model="match.team_two_id" class="right-col">
          <option v-for="team in teamList" :value="team.id">{{ team.name }}</option>
        </select>
      </fieldset>

      <fieldset class="row scores">
        <div class="left-col">
          <input type="number" v-model="match.team_one_score">
        </div>
        <span class="middle-col">:</span>
        <div class="right-col">
          <input type="number" v-model="match.team_two_score">
        </div>
      </fieldset>

      <button type="submit">{{ button }}</button>
    </form>
  </div>
</template>

<script>
  import { mapGetters } from 'vuex'

  export default {
    props: {
      button: String,
      match: Object,
    },
    data () {
      return {
        // fields: [
        //   { name: 'played_at', type: 'time' },
        // ],
      }
    },
    computed: mapGetters(['teamList', 'gameList']),
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

  .scores input {
    width: 60px;
  }
</style>
