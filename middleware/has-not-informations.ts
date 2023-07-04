/* eslint-disable no-undef */
export default defineNuxtRouteMiddleware(async (_to, _from) => {
  const me = await corn.me.me();
  if (me.firstTimeDate) {
    return navigateTo(Route.INDEX);
  }
});