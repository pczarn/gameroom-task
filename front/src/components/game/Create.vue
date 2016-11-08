<script>
import _ from 'lodash'
import * as action from 'src/store/action_types'
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
      await this.$store.dispatch(action.CREATE_GAME, this.game)
      this.game = this.$options.data().game
    },
  },
}
</script>
