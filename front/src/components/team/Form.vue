<script>
import _ from 'lodash'
import { mapGetters } from 'vuex'

export default {
  name: 'TeamForm',
  data () {
    const blankTeam = { name: '', members: [] }
    return {
      blankTeam,
      team: _.cloneDeep(this.currentTeam || blankTeam),
    }
  },
  computed: {
    ...mapGetters(['currentTeam']),
  },
}
</script>
