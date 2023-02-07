<script>
import { mapGetters } from 'vuex';
import ResourceTable from '@shell/components/ResourceTable';
import Loading from '@shell/components/Loading';
import { SCHEMA } from '@shell/config/types';

// TODO: rename to resource name
const macvlan = (spec, ctx) => {
  const that = {
    ...spec, _key: `key_${ spec.id }`, nameDisplay: spec.name
  };
  const availableActions = [{
    action:     'promptRemove',
    altAction:  'remove',
    label:      ctx.t('action.remove'),
    icon:       'icon icon-trash',
    bulkable:   true,
    bulkAction: 'promptRemove',
    enabled:    true
  }];
  const promptRemove = (resources) => {
    if ( !resources ) {
      resources = that;
    }
    const inStore = ctx.$store.getters['currentProduct'].inStore;

    ctx.$store.dispatch(`${ inStore }/promptRemove`, resources);
  };

  const currentRoute = () => {
    return window.$nuxt.$route;
  };
  const currentRouter = () => {
    return window.$nuxt.$router;
  };
  const remove = async() => {

  };

  that.availableActions = availableActions;
  that.promptRemove = promptRemove;
  that.currentRoute = currentRoute;
  that.currentRouter = currentRouter;
  that.remove = remove;

  return that;
};

export default {
  components: {
    Loading,
    ResourceTable,
  },
  async fetch() {},
  data() {
    return {
      schema: {
        id:   'ui-plugin.macvlan',
        type: SCHEMA
      },
      headers: [
        {
          name:     'id',
          labelKey: 'macvlan.tableHeaders.id',
        },
        {
          name:     'name',
          labelKey: 'tableHeaders.name',
        },
        {
          name:          'colorText',
          labelKey:      'macvlan.tableHeaders.colorText',
          formatter:     'ColorText',
          formatterOpts: { color: 'red' }
        },
      ],
      data: [{
        id:        '1',
        name:      'test1',
        colorText: 'color text1'
      },
      {
        id:        '2',
        name:      'test2',
        colorText: 'color text2',
      },
      {
        id:        '3',
        name:      'test3',
        colorText: 'color text3'
      },
      {
        id:        '4',
        name:      'test4',
        colorText: 'color text4'
      }],
    };
  },
  computed: {
    ...mapGetters(['currentCluster']),
    rows() {
      return this.data.reduce((total, c) => {
        total.push(macvlan(c, this));

        return total;
      }, []);
    }
  },
  methods: {
    async remove(btnCB) {

    }
  },
  mounted() {
    console.log(this.currentCluster);
  }
};
</script>
<template>
  <Loading v-if="$fetchState.pending" />
  <div v-else>
    <ResourceTable
      :schema="schema"
      :groupable="false"
      :headers="headers"
      :rows="rows"
      :namespaced="false"
      v-on="$listeners"
    >
      <template #cell:id="{value}">
        <span>ID: {{ value }}</span>
      </template>
    </ResourceTable>
  </div>
</template>
