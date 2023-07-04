<template>
  <TransitionGroup
    tag="div"
    name="slide"
    class="fixed bottom-4 right-4 w-11/12 overflow-hidden lg:w-4/12 z-50"
  >
    <div
      v-for="alert in alerts"
      :key="alert.id"
    >
      <Component
        :is="alert.alert.component"
        v-if="alert.alert.isCustom"
      />
      <CornAlert
        v-else
        :id="alert.id"
        :title="alert.alert.title"
        :content="alert.alert.content"
        :alertType="alert.alert.alertType"
        :autoClose="alert.alert.autoClose"
      />
    </div>
  </TransitionGroup>
</template>

<script lang="ts" setup>
import corn from '~~/corn';

const alerts = corn.alerts.alerts;
</script>

<style scoped lang="scss">
.slide-enter-from{
  transform: translateX(130%);
}
.slide-enter-to{
  transform: translateX(0);
}
.slide-leave-from{
  transform: translateX(0);
}

.slide-move{
  transition: all 0.5s ;
}

.slide-leave-to{
  transform: translateX(130%);
}
.slide-enter-active {
  transition: all 0.3s;
}
.slide-leave-active {
  transition: all 0.3s ;
}

</style>
