<template>
</template>

<script>
import Round from './Round'

export default {
  props: ['rounds'],
  data () {
    return {
      editable: false,
    }
  },
  components: {
    round: Round,
  },
}
</script>

<style scoped>
</style>
