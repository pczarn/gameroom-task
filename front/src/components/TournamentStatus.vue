<template>
<div class="tournament-status">
  <div class="boxes">
    <div class="label-box">{{ label }}</div>
    <div v-for="elem in slots" :class="['box', elem.class]">{{ elem.text }}</div>
  </div>
</div>
</template>

<script>
export default {
  name: 'TournamentStatus',
  props: {
    status: Object,
    label: String,
  },
  computed: {
    present () {
      return this.status.slots.map(([number, limit]) => {
        if(!limit) {
          return { class: 'full', text: number }
        } else {
          const defaultText = `${number}/${limit}`
          return {
            class: number == limit ? 'full' : 'present',
            text: defaultText,
          }
        }
      })
    },
    slots () {
      const rest = Array(this.status.size - this.present.length).fill({ class: '', text: '' })
      return this.present.concat(rest)
    },
  },
}
</script>

<style scoped>
.boxes .box, .boxes .label-box {
  height: 32px;
  line-height: 32px;
  text-align: center;
  display: inline-block;
  font-weight: bold;
}

.boxes .label-box {
  padding: 0 15px;
}

.boxes .box {
  width: 32px;
  border: 1px solid black;
  border-collapse: collapse;
}

.boxes .full {
  background-color: green;
}

.boxes .present {
  background-color: yellow;
}
</style>
