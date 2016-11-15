<template>
<form @submit.prevent="submit">
  <fieldset>
    <legend>Properties</legend>
    <template v-for="attrs in schema">
    <div :class="{ err: !!formErrors.password }">
      <p v-for="err in formErrors[attrs.name] || []">{{ err }}</p>
      <label :for="attrs.name">{{ attrs.label }}</label>
      <input v-bind="attrs" v-model="game[attrs.name]" :class="{ err: !!formErrors[attrs.name] }">
      <br>
    </template>
    <button type="submit">{{ buttonText }}</button>
  </fieldset>
</form>
</template>

<script>
import { mapGetters } from 'vuex'

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
  computed: {
    ...mapGetters(['formErrors']),
  },
}
</script>

<style scoped>
.err {
  border-color: red;
}
</style>
