<script>
import _ from 'lodash'
import { mapGetters } from 'vuex'
import AccountForm from './Form'

export default {
  name: 'AccountEdit',
  mixins: [AccountForm],
  data () {
    return {
      buttonText: 'Update account',
    }
  },
  created () {
    this.user = _.cloneDeep(this.currentUser)
  },
  computed: {
    ...mapGetters(['currentUser']),
  },
  methods: {
    submit () {
      this.$store.dispatch('UPDATE_USER', this.user)
    },
  },
}
</script>
