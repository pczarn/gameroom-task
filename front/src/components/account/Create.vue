<script>
import * as action from 'src/store/action_types'
import AccountForm from './Form'

export default {
  name: 'AccountEdit',
  mixins: [AccountForm],
  data () {
    return {
      buttonText: 'Register',
    }
  },
  methods: {
    submit () {
      this.$store.dispatch(action.CREATE_USER, this.user)
    },
  },
}
</script>
