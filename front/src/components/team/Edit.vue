<script>
import TeamForm from './Form'

export default {
  name: 'TeamEdit',
  mixins: [TeamForm],
  data () {
    return {
      buttonText: 'Update team',
    }
  },
  methods: {
    submit () {
      this.$store.dispatch('UPDATE_TEAM', this.team)
    },
  },
}
</script>
