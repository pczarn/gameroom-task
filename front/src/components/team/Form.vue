<script>
import _ from 'lodash'

export default {
  name: 'TeamForm',
  data () {
    const blankTeam = { name: '', members: [] }
    return {
      blankTeam,
      team: _.cloneDeep(this.$store.getters.currentTeam || blankTeam),
    }
  },
}
</script>
