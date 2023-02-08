<script>
import { escapeHtml } from '@shell/utils/string';
export default {
  props: {
    value: {
      type: Array,
      default() {
        return [];
      }
    },
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
  },
  computed: {
    plusMore() {
      const remaining = this.value.length - this.names.length;

      console.log(this.t('promptRemove.andOthers', { count: remaining }));

      return this.t('promptRemove.andOthers', { count: remaining });
    },
  },
  methods: {
    resourceNames(names) {
      return names.reduce((res, name, i) => {
        if (i >= 5) {
          return res;
        }
        res += `<b>${ escapeHtml( name ) }</b>`;
        if (i === names.length - 1) {
          res += this.plusMore;
        } else {
          res += i === names.length - 2 ? this.t('generic.and') : this.t('generic.comma');
        }

        return res;
      }, '');
    }
  }

};
</script>
<template>
  <div>
    <div>
      Custom Prompt Content
    </div>
    <br />
    {{ t('promptRemove.attemptingToRemove', { type }) }}
    <span v-html="resourceNames(names)"></span>
  </div>
</template>
