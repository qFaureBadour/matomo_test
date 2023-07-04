<template>
  <div>
    <h3 class="text-center text-lg font-bold text-gray-800">
      Réinitialisation du mot de passe
    </h3>
    <FormKit v-slot="{ state: { valid, loading } }" v-model="formData" type="form" :actions="false"
      @submit="launchProcess">
      <FormKit type="passwordStrong" name="password" autocomplete="one-time-code" label="Nouveau mot de passe"
        validation="required|strongPassword" />
      <FormKit type="password" label="Confirmation du mot de passe" name="password_confirm"
        validation="required | confirm" validationVisibility="dirty" autocomplete="one-time-code"
        :validationMessages="{ 'confirm': 'Les mots de passe ne sont pas identiques' }" />

      <div class="flex flex-row justify-end">
        <FormKit type="submit" class="shadow" :disabled="!valid">
          <span>
            Valider
          </span>
          <span class="ml-2">
            <Icon v-if="loading" iconName="spinner-third" :iconStyle="IconStyle.DUOTONE" class="animate-spin" />
            <Icon v-else iconName="arrow-right-to-arc" :iconStyle="IconStyle.DUOTONE" />
          </span>
        </FormKit>
      </div>
    </FormKit>
    <div class="text-sm mt-5 text-right">
      <button class="font-medium text-primary-400 hover:text-primary-500" @click="() => { navigateTo(Route.LOGIN) }">
        Retour à la connexion
      </button>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { AxiosError } from 'axios';

definePageMeta({
  layout: `center`,
  middleware: [`has-token`, 'is-not-auth']
});

let token = useRoute().query.token?.toString() ?? ``;;
const formData = ref();

async function launchProcess() {
  try {
    await corn.offline.resetPassword({ password: formData.value.password, password_confirmation: formData.value.password_confirm, token: token });
    corn.alerts.addAlert({ alertType: `success`, title: `Modification enregistré`, content: `votre nouveau mot de passe a été enregistré avec succès. Vous pouvez vous connecter` });
    await navigateTo(Route.LOGIN);
  } catch (e) {
    let errorMessage = `Votre mot de passe n'a pas pu être modifié`;
    if (e instanceof AxiosError && e.response?.data?.error?.message) {
      errorMessage = e.response?.data?.error?.message;
    }
    corn.alerts.addAlert({ alertType: `danger`, title: `Erreur`, content: errorMessage });
  }
}

</script>