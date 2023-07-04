<template>
  <div class="w-full px-16 py-16 bg-white rounded-corn">
    <div class="mb-4">
      <h2 class="text-3xl mb-2">
        Votre mot de passe a expiré
      </h2>
      <span> Pour votre sécurité, merci de le changer.</span>
    </div>
    <FormKit v-slot="{ state: { valid, loading } }" type="form"
      class="bg-white shadow-xl rounded-corn-xl px-8 pt-6 pb-8 mb-4" :actions="false" validationVisibility="dirty"
      name="renewal_form" @submit="(data: any, node?: FormKitNode) => onSubmit(data, node)">
      <FormKit label="Ancien mot de passe" name="old_password" type="password" autocomplete="current-password"
        validation="required" />
      <FormKit label="Nouveau mot de passe" name="password" type="passwordStrong" validation="strongPassword|required" />
      <FormKit label="Confirmation du mot de passe" name="password_confirm" type="password"
        validation="confirm|required" />
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
  </div>
</template>

<script lang="ts" setup>
import { AxiosError } from 'axios';
import { FormKitNode } from '@formkit/core';

const formLoading = ref(false);

async function onSubmit(data: any, node?: FormKitNode) {
  // eslint-disable-next-line camelcase
  const { old_password, password, password_confirm } = data;
  try {
    formLoading.value = true;
    await corn.me.changeMePassword(old_password, password, password_confirm);
    corn.modals.close();
    corn.alerts.addAlert({
      title: `Succès`,
      content: `Mot de passe modifié`,
      alertType: `success`,
      autoClose: true
    });
    node?.setErrors({
      big_form: `test`
    });
  } catch (error: any) {
    if (error instanceof AxiosError && error.response?.data.error.code === 4220) {
      node?.setErrors({
        ...error.response?.data.error.errors,
        big_form: `erro`
      }
      );
    } else {
      node?.setErrors({
        renewal_form: `Le mot de passe n'a pas été modifié. Vérifiez vos informations.`
      }
      );
    }
  } finally {
    formLoading.value = false;
  }
}
</script>