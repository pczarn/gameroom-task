<template>
<form @submit.prevent="submit">
  <fieldset>
    <legend>Properties</legend>
    <div>
      <p v-for="err in formErrors.name || []">{{ err }}</p>
      <label for="name">Name</label>
      <input type="text" name="name" v-model="game.name" :class="{ err: !!formErrors.name }">
    </div>
    <div>
      <p v-for="err in formErrors.image || []">{{ err }}</p>
      <label for="image">Image</label>
      <input type="file"
             name="image"
             accept="image/*"
             ref="image"
             @change="setImage"
             :class="{ err: !!formErrors.image }">
    </div>
    <button type="submit">{{ buttonText }}</button>
  </fieldset>
</form>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  data () {
    return {
      game: {},
    }
  },
  computed: {
    ...mapGetters(['formErrors']),
  },

  methods: {
    setImage () {
      const file = this.$refs.image.files[0]
      this.game.image = file
    },
  },
}
</script>

<style scoped>
.err {
  border-color: red;
}
</style>
