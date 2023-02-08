<script>
import { Card } from '@components/Card';

export default {
  components: { Card },

  props:      {
    resources: {
      type:     Array,
      required: true
    }
  },

  data() {
    return { };
  },

  methods: {
    close() {
      this.$emit('close');
    },
  }
};
</script>

<template>
  <Card
    class="prompt-rotate"
    :show-highlight-border="false"
  >
    <h4
      slot="title"
      class="text-default-text"
    >
      test title
    </h4>

    <div
      slot="body"
      class="pl-10 pr-10"
    >
      test body
    </div>

    <div
      slot="actions"
      class="buttons"
    >
      <button
        class="btn role-secondary mr-10"
        @click="close"
      >
        {{ t('generic.cancel') }}
      </button>

      <button
        class="btn role-primary"
        @click="close"
      >
        {{ t('generic.add') }}
      </button>
    </div>
  </Card>
</template>
<style lang='scss' scoped>
  .prompt-rotate {
    margin: 0;
  }
  .buttons {
    display: flex;
    justify-content: flex-end;
    width: 100%;
  }
</style>
