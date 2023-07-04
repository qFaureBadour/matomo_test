/* eslint-disable no-undef */
export default defineNuxtRouteMiddleware((_to, _from) => {
  if (!corn.auth.canAuthAsUser()) {
    return (Route.LOGIN);
  }
});