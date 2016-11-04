<script>
import _ from 'lodash'
import moment from 'moment'
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
    this.playedAtLocal = moment(this.match.playedAt).toISOString().replace('Z', '')
  },
  methods: {
    submit () {
      this.$store.dispatch(action.UPDATE_MATCH, this.match)
    },
  },
}
</script>
