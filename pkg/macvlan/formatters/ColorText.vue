<script>
export default {
  props: {
    value: {
      type:    String,
      default: ''
    },
    col: {
      type:    Object,
      default: () => {}
    },
    row: {
      type:    Object,
      default: () => {}
    },
    color: {
      type:    String,
      default: 'red'
    }
  },
};
</script>

<template>
  <span :style="{color: color}">
    {{ value }}
  </span>
</template>
