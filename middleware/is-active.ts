/* eslint-disable no-undef */
export default defineNuxtRouteMiddleware(async (_to, _from) => {
  const me = await corn.me.me();

  if (!me.activationDate) {
    return navigateTo(Route.ACTIVATE);
  }
});