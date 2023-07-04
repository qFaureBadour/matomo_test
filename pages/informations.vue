
<template>
  <div class="max-w-[700px]">

    <div class="mb-6">
      <Popper content="Retour à la connexion" openDelay="400" placement="top" hover>
        <button class="corn-button-outline-secondary" @click="() => { corn.auth.logOut() }" >
          <Icon iconName="arrow-right-to-arc" class="rotate-180"/>
        </button>
      </Popper>
      <h3 class="flex flex-col text-center text-lg text-gray-800">
        <span class="font-bold">Bonjour, <span class="font-extrabold">{{ me.firstName }}</span> !<br /></span>
        <span>Vérifie tes informations</span>
      </h3>
    </div>

    <FormKit id="first-connexion" ref="formulaire" v-slot="{ state: { valid, loading } }" type="form" :actions="false"
      :config="{ validationVisibility: 'live' }" @submit="onSubmit()">
      <div>
        <div v-if="pageState == 'view'">
          <div class="mb-5 text-danger">
            <div v-for="message, key in formErrorMessages" :key="key">
              {{ message }}
            </div>
          </div>

          <div>
            <div>
              <span class="mr-2">Civilité:</span><b class="font-bold">{{ informationResumeData.civility || '-' }}</b>
            </div>
            <div>
              <span class="mr-2">Raison Sociale:</span><b class="font-bold">{{ informationResumeData.companyName || '-'
              }}</b>
            </div>
            <div>
              <span class="mr-2">Nom:</span><b class="font-bold">{{ informationResumeData.surname || '-' }}</b>
            </div>
            <div>
              <span class="mr-2">Prénom:</span><b class="font-bold">{{ informationResumeData.firstname || '-' }}</b>
            </div>
            <div>
              <span class="mr-2">Adresse email:</span><b class="font-bold">{{ informationResumeData.email || '-' }}</b>
            </div>
            <div>
              <span class="mr-2">Adresse postale:</span><b class="font-bold">{{ informationResumeData.address || '-'
              }}</b>
            </div>
            <div>
              <span class="mr-2">Complément d'adresse:</span><b class="font-bold">{{
                informationResumeData.complementaryAddress || '-' }}</b>
            </div>
            <div>
              <span class="mr-2">Ville:</span><b class="font-bold">{{ informationResumeData.city || '-' }}</b>
            </div>
            <div>
              <span class="mr-2">Code postal:</span><b class="font-bold">{{ informationResumeData.zipcode || '-' }}</b>
            </div>
            <div>
              <span class="mr-2">Pays:</span><b class="font-bold">{{ informationResumeData.country?.countryTitle || '-'
              }}</b>
            </div>
            <div>
              <span class="mr-2">Téléphone mobile:</span><b class="font-bold">{{ informationResumeData.mobile || '-'
              }}</b>
            </div>
          </div>
        </div>

        <!-- --- -->

        <div v-show="pageState == 'edit'">
          <div>
            <FormKit v-model="formData.civility" type="select" :options="['Monsieur', 'Madame', 'Autre']" label="Civilité"
              validation="required" />
          </div>
          <div>
            <FormKit v-model="formData.companyName" type="text" label="Raison Sociale" validation="required" />
          </div>
          <div class="flex flex-col md:gap-2 md:flex-row ">
            <div class="flex-grow">
              <FormKit v-model="formData.surname" type="text" label="Nom" validation="required" />
            </div>
            <div class="flex-grow">
              <FormKit v-model="formData.firstname" name="firstname" type="text" label="Prénom" validation="required" />
            </div>
          </div>
          <FormKit v-model="formData.email" type="email" validation="required|email" label="Adresse email" />

          <FormKit v-model="formData.address" type="text" label="Adresse postale" validation="required" />
          <FormKit v-model="formData.complementaryAddress" type="text" label="Complément" />

          <div class="flex flex-col md:gap-2 md:flex-row ">
            <div class="flex-grow">
              <FormKit v-model="formData.city" type="text" label="Ville" validation="required" />
            </div>
            <div class="basis-1/3">
              <FormKit v-model="formData.zipcode" type="text" label="Code postal" validation="required" />
            </div>
          </div>
          <FormKit v-if="countries" v-model="formData.country" type="select" :options="countries"
            placeholder="Choisir un pays" validation="required" label="Pays" />
          <FormKit v-model="formData.mobile" type="tel" label="Téléphone mobile" placeholder="xxxxxxxxxx"
            validation="matches:/^[0-9]{10}$/|required" />
        </div>

        <div class="mt-10">
          <FormKit v-model="formData.has_optin_email" notResume type="checkbox" label="Communication par email"
            help="Voulez-vous recevoir les communicaiton par email ? " name="communicationByEmail" />
          <FormKit v-model="formData.has_optin_sms" notResume type="checkbox" label="Communication par SMS"
            help="Voulez-vous recevoir les communicaiton par SMS ? " name="communicationByPhone" />
        </div>

        <div class="flex flex-row justify-end items-center">
          <button type="button" class="corn-button-outline-primary mr-3" @click="toggleEditPage()">
            {{ pageState == 'view' ? 'Editer' : 'Voir resumé' }}
          </button>

          <FormKit type="submit" class="shadow" :disabled="!valid">
            <span>
              Enregistrer les informations
            </span>
            <span class="ml-2">
              <Icon v-if="loading" iconName="spinner-third" :iconStyle="IconStyle.DUOTONE" class="animate-spin" />
              <Icon v-else iconName="arrow-right-to-arc" :iconStyle="IconStyle.DUOTONE" />
            </span>
          </FormKit>
        </div>
      </div>
    </FormKit>

    <p class="mt-8 text-xs text-gray-400 hover:text-gray-600 leading-tight italic cursor-pointer">
      Les informations qui vous sont demandées sur le site sont utilisées pour les seules finalités suivantes : réaliser
      les opérations nécessaires à la gestion de votre compte utilisateur (exemple : gestion de vos commandes cadeaux,
      assistance personnalisée,…), vous communiquer des informations relatives à l'opération par emails et ou sms, générer
      des statistiques de visite afin d'améliorer votre expérience utilisateur. Le responsable de ce traitement est RHINOS
      SOLUTIONS. Le Délégué à la protection des données est disponible à l'adresse mail suivante : dpo@rhinos-groupe.com.
      Les services internes de RHINOS SOLUTIONS et les prestataires d'hébergement, de routage, transporteurs, imprimeurs
      et tous prestataires ou sous-traitants auquel la société RHINOS SOLUTIONS fait appel dans le cadre de l'exécution
      des commandes et de la fourniture des services proposés et contractuellement liés à RHINOS SOLUTIONS ainsi que
      <!-- TODO: CUSTOMER_NAME --> seront destinataires de ces informations. Les informations sont conservées pendant 5
      ans à compter de la date d'enregistrement. Conformément au Règlement européen sur la protection des données (RGPD),
      vous disposez du droit de demander, l'accès à vos données à caractère personnel, ainsi que leur rectification, leur
      effacement, la limitation du traitement, le droit de s'opposer au traitement ou le droit à la portabilité des
      données. Ces droits s'exercent auprès de RHINOS SOLUTIONS à l'adresse suivante : 13 avenue Paul Langevin 17180
      PERIGNY dont l'adresse mail est la suivante : contact@rhinos.fr. Vous disposez du droit d'introduire une réclamation
      auprès de la CNIL concernant le traitement de vos données.
    </p>
  </div>
</template>

<script lang="ts" setup>
import { FormKitOptionsItem } from '@formkit/inputs';
import { getValidationMessages } from '@formkit/validation';

definePageMeta({
  layout: `center`,
  middleware: [`is-auth`, `is-active`, `has-not-informations`]
});

type InformationsResume = Partial<{
  civility: string,
  companyName: string,
  firstname: string,
  surname: string,
  email: string,
  address: string,
  complementaryAddress: string,
  zipcode: string,
  city: string,
  country: { countryTitle: string, countryId: number },
  mobile: string,
  phone: string,
}>

const pageState = ref<'view' | 'edit'>(`view`);

const me = await corn.me.me();

const formulaire = ref();
const formErrorMessages = ref();
const countries = ref<FormKitOptionsItem[]>([]);

const formData = ref({
  civility: ``,
  companyName: ``,
  firstname: ``,
  surname: ``,
  email: ``,
  address: ``,
  complementaryAddress: ``,
  zipcode: ``,
  city: ``,
  country: Object(),
  phone: ``,
  mobile: ``,
  has_optin_sms: false,
  has_optin_email: false
});

const informationResumeData = computed((): InformationsResume => ({
  civility: formData.value.civility,
  companyName: formData.value.companyName,
  firstname: formData.value.firstname,
  surname: formData.value.surname,
  email: formData.value.email,
  address: formData.value.address,
  complementaryAddress: formData.value.complementaryAddress,
  zipcode: formData.value.zipcode,
  city: formData.value.city,
  country: formData.value.country,
  mobile: formData.value.mobile,
  phone: formData.value.mobile
}));

onMounted(() => {
  if (formulaire.value.node.context?.state.valid === false) {
    pageState.value = `edit`;
    generateFormErrorMessages();
  }
});

async function fetchCountriesAndConvertToFormKitOptionsItem() {
  countries.value = (await corn.divers.getCountries()).data.map(country => ({ value: { countryId: country.id, countryTitle: country.title }, label: country.title }));
}

// bind informations with Me
(async function init() {
  formData.value.civility = me.civility;
  formData.value.companyName = me.companyName;
  formData.value.firstname = me.firstName;
  formData.value.surname = me.lastName;
  formData.value.email = me.email;
  formData.value.address = me.address;
  formData.value.complementaryAddress = me.complementaryAddress;
  formData.value.zipcode = me.zipCode;
  formData.value.city = me.city;
  formData.value.country = me.countryId ? { countryId: me.countryId, countryTitle: me.countryTitle } : undefined;
  formData.value.mobile = me.mobile;
  formData.value.has_optin_email = me.hasOptinEmail;
  formData.value.has_optin_sms = me.hasOptinSms;
})()

await fetchCountriesAndConvertToFormKitOptionsItem();

// FUNCTIONS

function generateFormErrorMessages() {
  const validations = getValidationMessages(formulaire.value.node);
  const messages: any[] = [];

  validations.forEach((message: any) => {
    messages.push(message[0].value);
  });

  formErrorMessages.value = messages;
}

function toggleEditPage() {
  pageState.value = pageState.value === `edit` ? `view` : `edit`;

  generateFormErrorMessages();
}

async function onSubmit() {
  try {

    await corn.me.firstConnexion({
      civility: formData.value.civility,
      company_name: formData.value.companyName,
      firstname: formData.value.firstname,
      surname: formData.value.surname,
      email: formData.value.email,
      address: formData.value.address,
      complementary_address: formData.value.complementaryAddress,
      zipcode: formData.value.zipcode,
      city: formData.value.city,
      country_id: formData.value.country?.countryId,
      mobile: formData.value.mobile,
      has_optin_sms: formData.value.has_optin_sms,
      has_optin_email: formData.value.has_optin_email,
      has_accepted_terms: true,
      has_optin_push: true,
      phone: formData.value.mobile
    });

    // refresh me when edit it
    await corn.me.me({ forceRefresh: true })

    await navigateTo(Route.INDEX);
  } catch (error) {
    corn.alerts.addAlert({ title: `Erreur serveur`, content: `Le formulaire n'a pas pu être soumis.`, alertType: `danger` });
  }
}
</script>
