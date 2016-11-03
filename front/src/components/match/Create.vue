<script>
import _ from 'lodash'
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
      this.$store.dispatch('CREATE_MATCH', this.match)
      this.match = _.cloneDeep(this.blankMatch)
    },
  },
}
</script>
