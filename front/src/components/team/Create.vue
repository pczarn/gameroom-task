<script>
import _ from 'lodash'
import TeamForm from './Form'

export default {
  name: 'TeamCreate',
  mixins: [TeamForm],
  data () {
    return {
      buttonText: 'Create team',
    }
  },
  methods: {
    async submit () {
      await this.$store.dispatch('CREATE_TEAM', this.team)
      this.team = _.cloneDeep(this.blankTeam)
    },
  },
}
</script>
