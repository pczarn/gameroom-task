<script>
import _ from 'lodash'
import { mapGetters } from 'vuex'
import * as action from 'src/store/action_types'
import GameForm from './Form'

export default {
  name: 'GameEdit',
  mixins: [GameForm],
  data () {
    return {
      buttonText: 'Update the game',
    }
  },
  created () {
    this.game = _.cloneDeep(this.currentGame)
  },
  computed: {
    ...mapGetters(['currentGame']),
  },
  methods: {
    submit () {
      this.$store.dispatch(action.UPDATE_GAME, this.game)
    },
  },
}
</script>
