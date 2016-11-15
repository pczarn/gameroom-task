<script>
import { mapGetters } from 'vuex'

export default {
  name: 'TeamForm',

  data () {
    return {
      team: { name: '', members: [] },
    }
  },
  computed: {
    ...mapGetters(['formErrors']),
  },
}
</script>
