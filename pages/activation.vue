<template>
  <div>
    <Popper content="Retour à la connexion" openDelay="400" placement="top" hover>
      <button class="corn-button-outline-secondary" @click="() => { corn.auth.logOut() }" >
        <Icon iconName="arrow-right-to-arc" class="rotate-180"/>
      </button>
    </Popper>
    <div v-show="pageState === 'form'">
      <h3 class="text-center text-lg text-gray-800">
        <span class="font-bold">Bonjour, <span class="font-extrabold">{{ me.firstName }}</span> !<br /></span>
        <span>Active ton compte</span>
      </h3>
      <FormKit v-slot="{ state: { valid, loading } }" v-model="formData" type="form" :actions="false" @submit="onSubmit">
        <FormKit type="passwordStrong" label="Mot de passe" name="password" validation="required|strongPassword" />
        <FormKit type="password" label="Confirmation du mot de passe" name="password_confirm"
          validation="required | confirm" validationVisibility="dirty" autocomplete="one-time-code"
          :validationMessages="{ 'confirm': 'Les mots de passe ne sont pas identiques' }" />
        <FormKit type="tel" label="Numéro de téléphone" name="mobile" validation="number|matches:/^[0-9 ]{10}$/|required"
          :validationMessages="{
            'matches': 'Le numéro de téléphone doit contenir 10 chiffres.',
          }" validationVisibility="dirty" />
        <FormKit v-model="secretQuestionId" type="select" label="Question secrète" name="secret_question_id"
          placeholder="Choisissez une question secrète" validation="required" :options="secretQuestions" />
        <FormKit v-if="secretQuestionId" name="secret_answer" type="text" label="Votre réponse à la question secrète"
          validation="required" :validationMessages="{
            'required': 'La réponse à la question secrète est requise.'
          }" />

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
    <!--  -->
    <div v-show="pageState === 'verification'">
      <h3 class="text-center text-lg font-bold text-gray-800">
        Vérification par code
      </h3>

      <div class="mt-5 mb-5 w-3/4 m-auto flex flex-col">
        <Icon v-if="registerState === 'init'" iconName="key" class="mb-3" size="3x" />
        <Icon v-if="registerState === 'loading'" iconName="spinner-third" class="mb-3 animate-spin" size="3x" />
        <Icon v-if="registerState === 'error'" iconName="exclamation-circle" class="mb-3 text-red-500 animate-pulse"
          size="3x" />
        <Icon v-if="registerState === 'success'" iconName="check" class="mb-3 text-red-500 animate-pulse" size="3x" />
        <p class="text-center ">
          {{ verificationCodeMessage }}
        </p>
      </div>

      <div class="flex mt-3 justify-center align-center">
        <InputCode ref="codeInputRef" :digits="6" @onComplete="(code: string) => onCodeComplete(code)" />
      </div>

      <div class="text-center mt-4">
        <button type="button" class="underline py-2 text-sm text-slate-500" :disabled="loadingCode"
          @click="generateCode()">
          <Icon v-if="loadingCode" class="animate-spin" iconName="spinner-third" />
          <span v-else class="mx-3">
            Renvoyez-moi le code
          </span>
        </button>
      </div>
    </div>
    <!--  -->
    <div v-show="pageState === 'success'">
      <h3 class="text-center text-lg font-bold text-gray-800">
        Validé !
      </h3>

      <div class="mt-5 mb-5 flex flex-col m-auto">
        <Icon iconName="check" class=" text-green-300" size="3x" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">

definePageMeta({
  layout: `center`,
  middleware: [`is-auth`, `is-not-active`]
});

const me = await corn.me.me();

const pageState = ref<'form' | 'verification' | 'success'>(`form`);
const registerState = ref<'init' | 'loading' | 'success' | 'error'>(`init`);
const loadingCode = ref(false);
const codeInputRef = ref();

type FormData = {
  password?: string,
  password_confirm?: string,
  mobile?: string,
  secret_answer?: string,
  secret_question_id?: number,
  code_verification?: number
}
const formData = ref<FormData>();

const secretQuestions = (await corn.offline.getSecretQuestions()).data;

const verificationCodeMessage = ref(`Renseignez votre code de vérification`);
const secretQuestionId = ref(null); // for conditional input formkit

async function onSubmit() {
  await generateCode();
}

async function generateCode() {
  loadingCode.value = true;

  try {
    if (formData.value && formData.value.mobile) {
      await corn.twoFactor.postGenerateCode({
        username: me.login,
        mobile: formData.value.mobile.trim() // remove spaces
      });

      pageState.value = `verification`;
      registerState.value = `init`;
      verificationCodeMessage.value = `Renseigne ton code de vérification`;
    }
  } catch (e: any) {
    corn.alerts.addAlert({
      title: `Erreur`,
      content: e.response.data.error.message,
      alertType: `danger`
    });
  }

  loadingCode.value = false;
}

function clear() {
  codeInputRef.value.clearCode();
}

async function onCodeComplete(code: string) {
  try {
    registerState.value = `loading`;

    if (formData.value &&
      formData.value.password &&
      formData.value.password_confirm &&
      formData.value.mobile &&
      formData.value.secret_answer &&
      formData.value.secret_question_id
    ) {
      await corn.me.activate({
        password: formData.value?.password,
        password_confirmation: formData.value?.password_confirm,
        mobile: formData.value?.mobile,
        secret_answer: formData.value?.secret_answer,
        secret_question_id: formData.value?.secret_question_id,
        code_verification: code
      });

      // refresh me when edit it
      await corn.me.me({ forceRefresh: true})

      pageState.value = `success`;
      registerState.value = `success`;

      await navigateTo(Route.INDEX);
    }
  } catch (e) {
    clear();
    registerState.value = `error`;
    verificationCodeMessage.value = `Code invalide, rentre le code à nouveau`; // TODO: a tester l'erreur code
  }
}

</script>