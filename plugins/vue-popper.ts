// plugins/floating-vue.ts
import { defineNuxtPlugin } from '#app';
import Popper from 'vue3-popper';

// https://github.com/valgeirb/vue3-popper/blob/main/src/component/Popper.vue
// https://valgeirb.github.io/vue3-popper/guide/getting-started.html#component
export default defineNuxtPlugin(({ vueApp }) => {
  vueApp.component(`Popper`, Popper);
});