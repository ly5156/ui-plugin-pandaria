<script>
import { mapGetters } from 'vuex';
import Favorite from '@shell/components/nav/Favorite';
import TypeDescription from '@shell/components/TypeDescription';

/**
 * Resource List Masthead component.
 */
export default {

  name: 'ListPageMasthead',

  components: {
    Favorite,
    TypeDescription,
  },
  props: {
    resource: {
      type:     String,
      required: true,
    },
    favoriteResource: {
      type:     String,
      default: null
    },
    typeDisplay: {
      type:     String,
      required: true
    },
    isCreatable: {
      type:    Boolean,
      default: null,
    },
    createLocation: {
      type:    Object,
      default: null,
    },
    createButtonLabel: {
      type:    String,
      default: null
    },

    /**
     * Inherited global identifier prefix for tests
     * Define a term based on the parent component to avoid conflicts on multiple components
     */
    componentTestid: {
      type:    String,
      default: 'masthead'
    }
  },

  data() {
    return {};
  },

  computed: {
    ...mapGetters(['isExplorer']),

    resourceName() {
      return this.resource;
    },

    _createButtonlabel() {
      return this.createButtonLabel || this.t('resourceList.head.create');
    }

  },
};
</script>

<template>
  <header class="header-layout">
    <slot name="typeDescription">
      <TypeDescription :resource="resource" />
    </slot>
    <div class="title">
      <h1 class="m-0">
        {{ typeDisplay }} <Favorite
          v-if="isExplorer"
          :resource="favoriteResource || resource"
        />
      </h1>
    </div>
    <div class="actions-container">
      <slot name="actions">
        <div class="actions">
          <slot name="extraActions" />

          <slot name="createButton">
            <n-link
              v-if="createLocation && isCreatable"
              :to="createLocation"
              class="btn role-primary"
              :data-testid="componentTestid+'-create'"
            >
              {{ _createButtonlabel }}
            </n-link>
          </slot>
        </div>
      </slot>
    </div>
  </header>
</template>

<style lang="scss" scoped>
  .title {
    align-items: center;
    display: flex;
    h1 {
      margin: 0;
    }
  }
</style>
