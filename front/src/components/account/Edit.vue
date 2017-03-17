<script>
import _ from 'lodash'
import { mapGetters } from 'vuex'
import * as action from 'src/store/action_types'
import AccountForm from './Form'

export default {
  name: 'AccountEdit',
  mixins: [AccountForm],

  data () {
    return {
      buttonText: 'Update account',
    }
  },
  computed: {
    ...mapGetters(['currentUser']),
  },

  created () {
    this.user = _.cloneDeep(this.currentUser)
  },
  methods: {
    submit () {
      this.$store.dispatch(action.UPDATE_USER, this.user)
    },
  },
}
</script>
