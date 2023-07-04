import { defineNuxtRouteMiddleware } from "nuxt/app";
import corn from '../corn';
import { MandatoryPasswordRenewalModal } from "#components";

export default defineNuxtRouteMiddleware(async (_from, _to) => {
  const me = await corn.me.me();
  if (me.renewalPasswordDate && me.renewalPasswordDate.getTime() < Date.now()) {
    corn.modals.openCustomModal({
      component: MandatoryPasswordRenewalModal,
      dismissible: false
    });
  }
});