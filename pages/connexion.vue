<template>
  <div>
    <div v-show="pageState === PageState.login">
      <h3 class="text-center text-lg font-bold text-gray-800">
        Connexion
      </h3>
      <FormKit
        v-slot="{ state: { valid, loading } }"
        v-model="loginFormData"
        type="form"
        :actions="false"
        @submit="onLoginClick"
      >
        <FormKit
          label="Identifiant"
          name="username"
          type="text"
          validation="required"
          placeholder="Votre code client"
        />
        <FormKit
          label="Mot de passe"
          name="password"
          type="password"
          autocomplete="current-password"
          validation="required"
        />

        <FormKit
          type="checkbox"
          label="Se souvenir de moi"
          name="rememberMe"
        />

        <div
          class="flex flex-row justify-end"
        >
          <FormKit
            type="submit"
            class="shadow"
            :disabled="!valid"
          >
            <span>
              Valider
            </span>
            <span class="ml-2">
              <Icon
                v-if="loading"
                iconName="spinner-third"
                :iconStyle="IconStyle.DUOTONE"
                class="animate-spin"
              />
              <Icon
                v-else
                iconName="arrow-right-to-arc"
                :iconStyle="IconStyle.DUOTONE"
              />
            </span>
          </FormKit>
        </div>
      </FormKit>
      <div class="text-sm mt-5 text-right">
        <button
          class="font-medium text-primary-400 hover:text-primary-500"
          @click="onForgottenMdpClicked"
        >
          Mot de passe
          oublié?
        </button>
      </div>
    </div>
    <div v-show="pageState === PageState.twoFaAsked">
      <h3 class="text-center text-lg font-bold text-gray-800">
        Two-factor authentication
      </h3>

      <div class="mt-5 mb-5 w-3/4 m-auto flex flex-col">
        <Icon
          v-if="twoFactorTabState === 'init'"
          iconName="key"
          class="mb-3"
          size="3x"
        />
        <Icon
          v-if="twoFactorTabState === 'loading'"
          iconName="spinner-third"
          class="mb-3 animate-spin"
          size="3x"
        />
        <Icon
          v-if="twoFactorTabState === 'error'"
          iconName="exclamation-circle"
          class="mb-3 text-red-500 animate-pulse"
          size="3x"
        />
        <p class="text-center ">
          {{ verificationCodeMessage }}
        </p>
      </div>

      <div class="flex mt-3 justify-center align-center">
        <InputCode
          ref="codeInputRef"
          :digits="6"
          @onComplete="(code: string) => onCodeComplete(code)"
        />
      </div>

      <div class="text-center mt-4">
        <button
          type="button"
          class="underline py-2 text-sm text-slate-500"
          :disabled="loadingCode"
          @click="generateCode()"
        >
          <Icon
            v-if="loadingCode"
            class="animate-spin"
            iconName="spinner-third"
          />
          <span
            v-else
            class="mx-3"
          >
            Renvoyez-moi le code
          </span>
        </button>
      </div>
    </div>
    <div v-show="pageState === PageState.mdpForgotten">
      <h3 class="text-center text-lg font-bold text-gray-800">
        Réinitialisation du mot de passe
      </h3>
      <FormKit
        v-slot="{ state: { valid, loading } }"
        type="form"
        class="bg-white shadow-xl rounded-corn-xl px-8 pt-6 pb-8 mb-4"
        :actions="false"
        @submit="(data)=>onResetPasswordEmailClick(data)"
      >
        <div>
          <p class="text-xs text-gray-400 leading-tight italic max-w-[400px] text-center">
            Renseignez l'identifiant liée à votre compte et cliquez sur "valider". Vous
            recevrez ensuite par e-mail un lien vous
            permettant de créer facilement et en toute sécurité votre nouveau mot de passe.
          </p>
        </div>
        <FormKit
          label="Identifiant"
          name="login"
          type="email"
          validation="required|email"
          placeholder="Identifiant"
        />
        <div class="flex flex-row justify-end">
          <FormKit
            type="submit"
            class="shadow"
            :disabled="!valid"
          >
            <span>
              Envoyer
            </span>
            <span class="ml-2">
              <Icon
                v-if="loading"
                iconName="spinner-third"
                :iconStyle="IconStyle.DUOTONE"
                class="animate-spin"
              />
              <Icon
                v-else
                iconName="send"
              />
            </span>
          </FormKit>
        </div>
      </FormKit>

      <div class="text-sm mt-5 text-right">
        <button
          class="font-medium text-primary-400 hover:text-primary-500"
          @click="onBackToConnectionClicked"
        >
          Retour à la connexion
        </button>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { AxiosError } from 'axios';

definePageMeta({
  layout: `center`,
  middleware: [ `is-not-auth` ]
});

// Connexion Page State
enum PageState{
  login,
  mdpForgotten,
  twoFaAsked,
}
const pageState = ref(PageState.login);

const loginFormData = ref();

function onForgottenMdpClicked() {
  pageState.value = PageState.mdpForgotten;
}

async function onLoginClick() {
  try {
    await corn.auth.logIn({ username: loginFormData.value.username, password: loginFormData.value.password, persistUserConnexion: loginFormData.value.rememberMe });
    await navigateTo(Route.INDEX);
  } catch (e) {
    if (e instanceof CornCodeError) {
      pageState.value = PageState.twoFaAsked;
    } else {
      let errorMessage = `Echec de la connexion. Merci de vérifier vos identifiants.`;
      if (e instanceof AxiosError) {
        errorMessage = e.response?.data.error.message;
      }
      corn.alerts.addAlert({ alertType: `danger`, content: errorMessage, title: `Erreur` });
    }
  }
}

// TwoFactorTab
const codeInputRef = ref();
const loadingCode = ref(false);
const twoFactorTabState = ref<'init'|'loading' |'error'>(`init`);
const verificationCodeMessage = ref(`Renseignez votre code de vérification`);

async function onCodeComplete(code: string) {
  try {
    twoFactorTabState.value = `loading`;
    await corn.auth.logIn({ code: code, username: loginFormData.value.username, password: loginFormData.value.password, persistUserConnexion: loginFormData.value.persistUserConnexion });
    document.location = Route.INDEX;
  } catch (e) {
    clearCode();
    twoFactorTabState.value = `error`;
    verificationCodeMessage.value = `Code invalide, rentrez le code à nouveau`;
  }
}

async function generateCode() {
  loadingCode.value = true;
  try {
    if (loginFormData.value && loginFormData.value.username) {
      await corn.twoFactor.postGenerateCode({
        username: loginFormData.value.username
      });
      twoFactorTabState.value = `init`;
      verificationCodeMessage.value = `Renseignez votre code de vérification`;
      corn.alerts.addAlert({
        title: `Envoyé avec succès`,
        content: `Un nouveau code a été envoyé`,
        alertType: `success`
      });
    }
  } catch (e :any) {
    corn.alerts.addAlert({
      title: `Erreur`,
      content: e.response.data.error.message,
      alertType: `danger`
    });
    verificationCodeMessage.value = `Le code n'a pas été envoyé. Veuillez réessayer plus tard`;
  } finally {
    loadingCode.value = false;
  }
}

function clearCode() {
  codeInputRef.value.clearCode();
}

function onBackToConnectionClicked() {
  pageState.value = PageState.login;
}

async function onResetPasswordEmailClick(data:Record<string, any>) {
  try {
    await corn.offline.sendResetPasswordMail({ login: data.login });
    corn.alerts.addAlert({
      title: `Email envoyé`,
      content: `Veuillez vérifier votre boite email`,
      alertType: `success`,
      autoClose: false
    });
    pageState.value = PageState.login;
  } catch (e: any) {
    let errorMessage = `L'email n'a pas pu être envoyé. Veuillez réessayer plus tard.`;
    if (e instanceof AxiosError) {
      errorMessage = e.response?.data?.error?.message ?? errorMessage + ` .code: ` + e;
    }
    corn.alerts.addAlert({ alertType: `danger`, content: errorMessage, title: `Erreur` });
  }
}

</script>