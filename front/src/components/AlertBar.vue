<template>
<div>
  {{ alert }}
</div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: mapGetters(['alert']),
}
</script>

<style scoped>
div {
  background-color: yellow;
}
</style>
