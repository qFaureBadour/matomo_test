<template>
  <div class="bg-white p-8 w-11/12 m-auto md:max-w-lg rounded-corn-xl relative bg">
    <div
      v-if="dismissible"
      class="absolute top-0 right-0 text-gray-500 m-5 cursor-pointer"
      @click="onCloseClick"
    >
      <FontAwesomeIcon
        icon="fal fa-xmark"
        size="lg"
      />
    </div>
    <div class="font-semibold mb-2 text-xl">
      {{ title }}
    </div>
    <slot>
      <div>
        {{ content }}
      </div>
    </slot>
    <div
      v-if="submitButton || cancelButton"
      class="flex flex-row-reverse gap-2 mt-5"
    >
      <button
        v-if="submitButton"
        type="button"
        class="corn-button-primary"
        @click="onValidateClick"
      >
        {{ submitButton }}
      </button>
      <button
        v-if="cancelButton"
        type="button"
        class="corn-button-outline-primary"
        @click="onCancelClick"
      >
        {{ cancelButton }}
      </button>
    </div>
  </div>
</template>

<script setup lang="tsx">
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { PropType } from 'vue';
import { ModalEvent } from '~~/_corn/_modals/_modals';

const props = defineProps({
  title: { type: String },
  content: { type: String },
  submitButton: String,
  cancelButton: {
    type: String
  },
  onModalEvent: {
    type: Function as PropType<(dismiss:ModalEvent)=>void>
  },
  dismissible: {
    type: Boolean,
    default: true
  }
});

function onValidateClick() {
  if (props.onModalEvent) {
    props.onModalEvent(ModalEvent.OK);
  }
  corn.modals.close();
}
function onCancelClick() {
  if (props.onModalEvent) {
    props.onModalEvent(ModalEvent.CANCELLED);
  }
  corn.modals.close();
}
function onCloseClick() {
  if (props.onModalEvent) {
    props.onModalEvent(ModalEvent.DISMISSED);
  }
  corn.modals.close();
}

</script>

<style scoped lang="scss">
.bounce-enter-active {
  animation: bounce-in 0.5s;
}
.bounce-leave-active {
  animation: bounce-in 0.5s reverse;
}
@keyframes bounce-in {
  0% {
    transform: scale(0);
  }
  50% {
    transform: scale(1.25);
  }
  100% {
    transform: scale(1);
  }
}
</style>