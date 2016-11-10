<template>
<form @submit.prevent="submit">
  <fieldset>
    <legend>Properties</legend>
    <template v-for="attrs in schema">
      <label :for="attrs.name">{{ attrs.label }}</label>
      <input v-bind="attrs" v-model="game[attrs.name]">
      <br>
    </template>
    <button type="submit">{{ buttonText }}</button>
  </fieldset>
</form>
</template>

<script>
export default {
  data () {
    return {
      schema: [
        { name: 'name', label: 'Name', type: 'text' },
        { name: 'image', label: 'Image', type: 'file', accept: 'image/*' },
      ],
      game: {},
    }
  },
}
</script>
