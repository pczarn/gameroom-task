<template>
<form @submit.prevent="submit">
  <fieldset>
    <legend>Properties</legend>
    <template v-for="attrs in schema">
      <label :for="attrs.name">{{ attrs.label }}</label>
      <input v-bind="attrs" v-model="game[attrs.name]">
    </template>
    <button type="submit">Add the game</button>
  </fieldset>
</form>
</template>

<script>
import Vue from 'vue'
import _ from 'lodash'

export default {
  props: {
    value: Object,
  },
  data () {
    return {
      schema: [
        { name: 'name', label: 'Name', type: 'text' },
        { name: 'image', label: 'Image', type: 'file', accept: 'image/*' },
      ],
      game: _.cloneDeep(this.value),
    }
  },
  methods: {
    submit() {
      this.$emit('submit', this.game)
    },
  },
}
</script>
