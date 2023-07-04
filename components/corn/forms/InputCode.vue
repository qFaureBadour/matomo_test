<template>
  <input
    v-for="index in digits"
    :key="index"
    type="number"
    maxlength="1"
    :disabled="disableFields"
    :value="tmp[index - 1] || ''"
    class="w-8 h-8 md:w-12 md:h-12 mx-2 text-xl font-bold text-gris-700 leading-tight text-center border-2 rounded-corn disabled:bg-slate-100 disabled:border-slate-100 disabled:animate-ping focus:outline-none focus:border-primary"
    :style="`animation-delay: ${index * 80}ms`"
    @keydown.delete.stop="handleInputDelete(index - 1, $event.target as HTMLInputElement)"
    @input="handleInput(index - 1, $event.target as HTMLInputElement)"
    @focus="(e)=>handleFocus(e.target as HTMLInputElement)"
    @paste="(e)=>handlePaste(e as ClipboardEvent)"
  >
</template>

<script setup lang="ts">
import { ref } from 'vue';

const props = defineProps({
  digits: {
    type: Number,
    required: true
  }
});

const emit = defineEmits([ `input`, `onComplete` ]);
defineExpose({ clearCode });

const tmp = ref(``);
const disableFields = ref(false);

function clearCode() {
  tmp.value = ``;
  disableFields.value = false;
}

function handleInputDelete(index: number, element: HTMLInputElement) {
  // Get all the digit inputs
  const inputs = element.parentElement?.querySelectorAll(`input`);

  if (index > 0 && inputs) {
    const prevItem = inputs.item(index - 1);

    if (prevItem !== undefined) {
      prevItem.focus();
      prevItem.value = ``;
    }
  }
}

/**
 * Handle input, advancing or retreating focus.
 */
function handleInput(index:number, e:HTMLInputElement) {
  const prev = tmp.value;

  if (tmp.value.length <= index) {
    // If this is a new digit
    tmp.value = `` + tmp.value + e.value;
  } else {
    // If this digit is in the middle somewhere, cut the string into two
    // pieces at the index, and insert our new digit in.
    tmp.value =
      `` +
      tmp.value.substring(0, index) +
      e.value +
      tmp.value.substring(index + 1);
  }

  // Get all the digit inputs
  const inputs = e.parentElement?.querySelectorAll(`input`);

  if (index < props.digits - 1 && tmp.value.length >= prev.length) {
    // If this is a new input and not at the end, focus the next input
    inputs?.item(index + 1).focus();
  } else if (index > 0 && tmp.value.length < prev.length) {
    // in this case we deleted a value, focus backwards
    inputs?.item(index - 1).focus();
  }

  if (tmp.value.length === props.digits) {
    // If our input is complete, commit the value.*
    inputs?.item(index).blur();
    disableFields.value = true;
    emit(`onComplete`, tmp.value);
  }
}

/**
 * On focus, select the text in our input.
 */
function handleFocus(target:HTMLInputElement) {
  target.select();
}

/**
 * Handle the paste event.
 */
function handlePaste(e:ClipboardEvent) {
  if (!e.clipboardData) {
    return;
  }
  const paste = e.clipboardData.getData(`text`);
  if (isNaN(parseInt(paste)) || paste.length !== props.digits) {
    e.preventDefault();
    return;
  }
  const inputs = (e.target as HTMLInputElement)?.parentElement?.querySelectorAll(`input`);
  if (typeof paste === `string`) {
    // If it is the right length, paste it.
    tmp.value = paste.substring(0, props.digits);
    // Focus on the last character
    inputs?.item(tmp.value.length - 1).focus();
  }
  if (tmp.value.length === props.digits) {
    inputs?.item(tmp.value.length - 1).blur();
    disableFields.value = true;
    emit(`onComplete`, tmp.value);
  }
}
</script>

<style scoped lang="scss">
/* Chrome, Safari, Edge, Opera */
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

/* Firefox */
input[type=number] {
  -moz-appearance: textfield;
}
</style>