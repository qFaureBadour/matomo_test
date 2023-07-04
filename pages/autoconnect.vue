<template>
  <div class="flex h-80 items-center justify-center w-40 mx-auto aspect-square">
    <span class="mr-2 text-md font-semibold">
      Auto-connexion
    </span>
    <span class="absolute scale-125 animate-pulse transition">
      <Icon
        v-if="!errorMessage"
        class="animate-spin"
        iconName="circle-notch"
        iconStyle="fat"
        size="10x"
      />
      <Icon
        v-else
        class="text-danger"
        iconName="circle"
        iconStyle="fat"
        size="10x"
      />
    </span>
  </div>
  <div
    v-if="errorMessage"
    class="text- text-center text-danger"
  >
    <div class="font-bold">
      <Icon
        iconName="warning"
        class="mr-1"
      />Erreur
    </div>
    {{ errorMessage }}
  </div>
</template>

<script lang="ts" setup>
import { AxiosError } from 'axios';

definePageMeta({
  layout: `center`
});

const errorMessage = ref();
const token = useRoute().query.token?.toString();

if (!token) {
  awaitError();
} else {
  autoConnect(token);
}

async function autoConnect(token:string) {
  const resp = await Promise.all([
    await fetch(token),
    await new Promise(resolve => setTimeout(resolve, 1500))
  ]);
  if (resp[0] instanceof AxiosError) {
    errorMessage.value = resp[0].response?.data.error.message ?? `Erreur de connexion`;
  } else if (resp[0] instanceof Error) {
    errorMessage.value = `Erreur de connexion`;
  } else {
    reloadNuxtApp({ path: Route.INDEX, ttl: 500 })
  }
}

async function fetch(token:string):Promise<any> {
  try {
    await corn.auth.autoConnect({ token: token });
    return ``;
  } catch (e) {
    return e;
  }
}

async function awaitError() {
  await new Promise(resolve => setTimeout(resolve, 1500));
  errorMessage.value = `Lien non valide`;
}

</script>