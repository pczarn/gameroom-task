<script>
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
      this.$store.dispatch('CREATE_USER', this.user)
    },
  },
}
</script>
