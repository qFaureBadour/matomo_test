import { library, config } from '@fortawesome/fontawesome-svg-core';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { fas } from '@fortawesome/pro-solid-svg-icons';
import { far } from '@fortawesome/pro-regular-svg-icons';
import { fal } from '@fortawesome/pro-light-svg-icons';
import { fat } from '@fortawesome/pro-thin-svg-icons';
import { fad } from '@fortawesome/pro-duotone-svg-icons';
import { fass } from '@fortawesome/sharp-solid-svg-icons';
import { defineNuxtPlugin } from '#app';
// This is important, we are going to let Nuxt worry about the CSS
config.autoAddCss = false;

// You can add your icons directly in this plugin. See other examples for how you
// can add other styles or just individual icons.
library.add(fas, far, fal, fat, fad, fass);

export default defineNuxtPlugin((nuxtApp) => {
  nuxtApp.vueApp.component(`font-awesome-icon`, FontAwesomeIcon);
  nuxtApp.vueApp.component(`FontAwesomeIcon`, FontAwesomeIcon);
});
