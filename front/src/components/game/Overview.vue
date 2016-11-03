<template>
<div class="game">
  <img :src="image_thumb_url">
  <router-link :to="{ name: 'game', params: { id: id } }">
    <strong>{{ name }}</strong>
  </router-link>
</div>
</template>

<script>
export default {
  props: {
    id: Number,
    name: String,
    archivized: Boolean,
    image_url: String,
    image_thumb_url: String,
  },
  data () {
    return {
    }
  },
}
</script>
