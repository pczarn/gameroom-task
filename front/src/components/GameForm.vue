<template>
<form @submit.prevent="$emit('submit', game)">
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
    }
  },
  computed: {
    game () {
      return Vue.util.extend({}, this.value)
    },
  },
}
</script>
