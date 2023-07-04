/* eslint-disable no-undef */
export default defineNuxtRouteMiddleware(async (_to, _from) => {
  if (!_to.query.token) {
    return navigateTo(Route.INDEX);
  }
});