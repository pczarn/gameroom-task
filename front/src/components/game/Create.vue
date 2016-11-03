<script>
import GameForm from './Form'

export default {
  name: 'GameCreate',
  mixins: [GameForm],
  data () {
    return {
      buttonText: 'Add the game',
    }
  },
  methods: {
    async submit () {
      await this.$store.dispatch('CREATE_GAME', this.gameClone)
      this.gameClone = {}
    },
  },
}
</script>
