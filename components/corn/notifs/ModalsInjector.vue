<template>
  <div
    v-if="modal"
    class="fixed flex w-screen h-screen z-50"
  >
    <div
      class="barrier top-0  bottom-0 left-0 right-0 fixed bg-black/80 "
      @click="onBarrierClick"
    ></div>
    <div class="content m-auto">
      <CornModal
        :title="modal.title"
        :content="modal.content"
        :submitButton="modal.submitButton"
        :cancelButton="modal.cancelButton"
        :onModalEvent="modal.onModalEvent"
        :dismissible="modal.dismissible"
      />
    </div>
  </div>
  <div
    v-if="customModal"
    class="fixed flex w-screen h-screen z-50"
  >
    <div
      class="barrier top-0  bottom-0 left-0 right-0 fixed bg-black/80 "
      @click="onBarrierClick"
    ></div>
    <div class="content m-auto">
      <Component :is="customModal.component" />
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ModalEvent } from '~~/_corn/_modals/_modals';

const modal = corn.modals.modal;
const customModal = corn.modals.customModal;

function onBarrierClick() {
  if (modal.value?.dismissible) {
    if (modal.value?.onModalEvent) {
      modal.value?.onModalEvent(ModalEvent.DISMISSED);
    }
    corn.modals.close();
  }
  if (customModal.value?.dismissible) {
    if (customModal.value?.onBarrierDismiss) {
      customModal.value?.onBarrierDismiss();
    }
    corn.modals.close();
  }
}
</script>

<style scoped lang="scss">
.content{
  position: relative;
  max-width: 100%;
  max-height: 100%;
}
</style>