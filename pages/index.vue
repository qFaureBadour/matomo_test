
<template>
  <div class="flex flex-col pt-28 items-center">

    <h1 class="font-mono text-4xl mb-10">
      Bienvenidos a todos!
      <Icon iconName="pinata" size="2x" />
    </h1>
    <div class="text-center">
      <img v-if="clicked" src="~/assets/img/nous.jpg" alt="BOOM !" width="450" :class="animate ? 'animate-spin' : ''">
      <button v-else class="corn-button-outline-danger" @click="click">
        AY TEQUILA !
      </button>

      <iframe v-if="play" width="0" height="0" src="https://www.youtube.com/embed/4hswHOEQfj8?start=52&autoplay=1"
        title="YouTube video player" frameborder="0"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
        allowfullscreen></iframe>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

definePageMeta({
  middleware: [ `is-auth`, `is-active`, `has-informations`, `needs-password-renewal` ]
});

const clicked = ref<boolean>(false);
const animate = ref<boolean>(false);
const play = ref<boolean>(false);

async function click() {
  clicked.value = true;
  play.value = true;

  setTimeout(() => {
    animate.value = true;
  }, 1500);
}
</script>
