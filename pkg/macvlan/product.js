export function init($plugin, store) {
  // const { product } = $plugin.DSL(store, $plugin.name);
  const { product, virtualType } = $plugin.DSL(store, 'explorer');

  // product({
  //   icon:                  'gear',
  //   inStore:               'management',
  //   removable:             false,
  //   showClusterSwitcher:   false,
  // });

  virtualType({
    label:      'macvlan',
    labelKey:   'nav.vlanSubnet.label',
    name:       'macvlan-subnet',
    group:      'cluster',
    namespaced: false,
    icon:       'globe',
    route:      { name: 'macvlan-c-cluster'},
    exact:      true
  });
}
