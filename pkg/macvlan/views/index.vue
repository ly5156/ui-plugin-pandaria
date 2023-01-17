<script>
import { mapGetters } from 'vuex';
export default {
  data() {
    return {};
  },
  computed: { ...mapGetters(['currentCluster']) },
  mounted() {
    console.log(this.currentCluster);
  }
};
</script>
<template>
  <div>
    test macvlan index page
    curruent cluster id: {{ currentCluster.id }}
    <div>
    </div>
  </div>
</template>
