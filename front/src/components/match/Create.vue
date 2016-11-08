<script>
import _ from 'lodash'
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
    submit () {
      this.$store.dispatch(action.CREATE_MATCH, this.match)
      this.match = this.$options.data().match
    },
  },
}
</script>
