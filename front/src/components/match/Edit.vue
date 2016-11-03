<script>
import MatchForm from './Form'

export default {
  name: 'MatchEdit',
  mixins: [MatchForm],
  data () {
    return {
      buttonText: 'Update match',
    }
  },
  methods: {
    submit () {
      this.$store.dispatch('UPDATE_MATCH', this.match)
    },
  },
}
</script>
