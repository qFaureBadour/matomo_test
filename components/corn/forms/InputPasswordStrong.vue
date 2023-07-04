<template>
  <input
    ref="passwordInputRef"
    v-model="passwordValue"
    type="password"
    class="border rounded-corn w-full py-2 px-3 text-gray-700 leading-tight focus:outline-primary focus:shadow-outline"
    :placeholder="context.placeholder"
    @input="(val: Event) => { handlePasswordInput(val) }"
  >
  <div class="p-2 text-xs text-slate-500">
    <div>
      <p class="mb-1">
        Votre mot de passe doit au moins contenir:
      </p>
      <span
        v-for="rule, key in passwordRules"
        :key="key"
        class="flex flex-col"
      >
        <span
          class="flex items-center"
          :class="!passwordValue ? 'text-slate-600/75' : rule.valid ? 'text-green-600/75' : 'text-red-500/75'"
        >
          <Icon
            :iconName="!passwordValue ? 'circle-dashed' : rule.valid ? 'circle-check' : 'circle-xmark'"
            class="mr-2"
          />
          {{ rule.desc }}
        </span>
      </span>
    </div>
  </div>
</template>

<script lang="ts" setup>
const props = defineProps<{
  context: any
}>();
const passwordInputRef = ref();

const passwordValue = ref<string>(props.context.node.value || ``);
const passwordValid = ref(false);
const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[`~!@#$%^&*()_|+\-=?;:'",.<>{}[\]\\/])(?!.+ ).{8,32}$/;

type PasswordRule = {
  name: string,
  rule: RegExp,
  desc: string,
  valid: boolean
}

const passwordRules = ref<PasswordRule[]>([
  {
    name: `matchLowercase`,
    desc: `une lettre minuscule`,
    rule: /(?=.*[a-z])/,
    valid: false
  },
  {
    name: `matchUppercase`,
    desc: `une lettre majuscule`,
    rule: /(?=.*[A-Z])/,
    valid: false
  },
  {
    name: `matchNumber`,
    desc: `un chiffre`,
    rule: /(?=.*[0-9])/,
    valid: false
  },
  {
    name: `matchSpecialchars`,
    desc: `un caractère spécial`,
    rule: /(?=.*[`~!@#$%^&*()_|+\-=?;:'",.<>{}[\]\\/])/,
    valid: false
  },
  {
    name: `matchLength`,
    desc: `entre 8 et 32 caractères`,
    rule: /^.{8,32}$/,
    valid: false
  },
  {
    name: `matchNotSpace`,
    desc: `sans espace`,
    rule: /^(?!.+ ).*$/,
    valid: true
  }
]);

function handlePasswordInput(event: Event) {
  const value = (event.target as HTMLInputElement).value;

  passwordValue.value = value;
  passwordValid.value = !!value.match(passwordRegex);

  passwordRules.value.forEach(rule => {
    rule.valid = !!value.match(rule.rule);
  });

  // input to formkit
  props.context?.node.input(passwordValue.value || undefined);
}
</script>
