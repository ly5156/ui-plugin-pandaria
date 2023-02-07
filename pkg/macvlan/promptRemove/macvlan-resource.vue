<script>
import { escapeHtml, resourceNames } from '@shell/utils/string';
export default {
  props: {
    type: {
      type:    String,
      default: ''
    },
    names: {
      type: Array,
      default() {
        return [];
      }
    },
    plusMore: {
      type:    String,
      default: ''
    }
  },
  methods: { resourceNames }

};
</script>
<template>
  <div>
    <div>
      Custom Prompt Content
    </div>
    <br />
    {{ t('promptRemove.attemptingToRemove', { type }) }} <span
      v-html="resourceNames(names, plusMore, t)"
    />
  </div>
</template>
