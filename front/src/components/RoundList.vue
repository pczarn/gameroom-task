<template>
</template>

<script>
import Round from './Round'

export default {
  data () {
    return {
      editable: false,
    }
  },
  props: ['rounds'],
  components: {
    round: Round,
  },
}
</script>

<style scoped>
</style>
