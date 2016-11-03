<template>
<form @submit.prevent="submit">
  <fieldset>
    <legend>Properties</legend>
    <template v-for="attrs in schema">
      <label :for="attrs.name">{{ attrs.label }}</label>
      <input v-bind="attrs" v-model="gameClone[attrs.name]">
    </template>
    <button type="submit">{{ buttonText }}</button>
  </fieldset>
</form>
</template>

<script>
import _ from 'lodash'

export default {
  props: {
    game: {
      type: Object,
      default () {
        return {}
      },
    },
  },
  data () {
    return {
      schema: [
        { name: 'name', label: 'Name', type: 'text' },
        { name: 'image', label: 'Image', type: 'file', accept: 'image/*' },
      ],
      gameClone: _.cloneDeep(this.game),
    }
  },
}
</script>
