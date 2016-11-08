<script>
import _ from 'lodash'
import * as action from 'src/store/action_types'
import MatchForm from './Form'

export default {
  name: 'MatchEdit',
  mixins: [MatchForm],

  data () {
    return {
      buttonText: 'Update match',
    }
  },

  created () {
    this.match = _.cloneDeep(this.currentMatch)
  },
  methods: {
    submit () {
      this.$store.dispatch(action.UPDATE_FRIENDLY_MATCH, this.match)
    },
  },
}
</script>
