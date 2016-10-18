<template>
<div class="game">
  <img :src="image_thumb_url">
  <strong>{{ name }}</strong>
  <button v-if="editable" @click="$emit('remove')">Remove</button>
</div>
</template>

<script>
export default {
  data () {
    return {
    }
  },
  props: ['id', 'name', 'state_archivized', 'image_url', 'image_thumb_url', 'editable'],
}
</script>

<style scoped>
h1 {
  color: #42b983;
}
</style>
