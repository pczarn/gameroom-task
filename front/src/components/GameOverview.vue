<template>
<div class="game">
  <img :src="image_thumb_url">
  <router-link :to="{ name: 'games', params: { id: id } }">
    <strong>{{ name }}</strong>
  </router-link>
  <button v-if="editable" @click="$emit('remove')">Remove</button>
</div>
</template>

<script>
import { mapGetters } from 'vuex'

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
  computed: {
    editable () {
      return this.isAdmin
    },
    ...mapGetters(['isAdmin']),
  },
}
</script>
