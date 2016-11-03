<script>
import GameForm from './Form'

export default {
  name: 'GameEdit',
  mixins: [GameForm],
  data () {
    return {
      buttonText: 'Update the game',
    }
  },
  methods: {
    submit () {
      this.$store.dispatch('UPDATE_GAME', this.game)
    },
  },
}
</script>
