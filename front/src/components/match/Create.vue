<script>
import * as action from 'src/store/action_types'
import MatchForm from './Form'

export default {
  name: 'MatchCreate',
  mixins: [MatchForm],

  data () {
    return {
      buttonText: 'Create match',
    }
  },

  methods: {
    async submit () {
      await this.$store.dispatch(action.CREATE_FRIENDLY_MATCH, this.match)
      this.match = this.$options.data().match
    },
  },
}
</script>
