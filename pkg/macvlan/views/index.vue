<script>
import { mapGetters } from 'vuex';
export default {
  data() {
    
    return {}
  },
  computed: {
    ...mapGetters(['currentCluster']),
  },
  mounted() {
    console.log(this.currentCluster)
  }
}
</script>
<template>
  <div>
    test macvlan index page
    当前集群ID：{{ currentCluster.id }}
    <div>
      json: {{ JSON.stringify(currentCluster) }}
    </div>
  </div>
</template>