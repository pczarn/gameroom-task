<template>
<div class="game">
  <img :src="imageThumbUrl">
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
    imageUrl: String,
    imageThumbUrl: String,
  },
}
</script>
