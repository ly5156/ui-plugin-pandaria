import { importTypes } from '@rancher/auto-import';
import { IPlugin } from '@shell/core/types';
import MacvlanIndex from './views/index.vue';

const PRODUCT_NAME = 'macvlan';

// Init the package
export default function(plugin: IPlugin) {
  // Auto-import model, detail, edit from the folders
  importTypes(plugin);

  // Provide plugin metadata from package.json
  plugin.metadata = require('./package.json');

  // Load a product
  plugin.addProduct(require('./product'));

  plugin.addRoute({
    name:      `${ PRODUCT_NAME }-c-cluster`,
    path:      '/:product/c/:cluster/:resource',
    component: MacvlanIndex
  });
}
