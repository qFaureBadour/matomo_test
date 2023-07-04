import { defineNuxtPlugin, useRuntimeConfig } from "#app";
import corn from "../corn";

export default defineNuxtPlugin(_nuxtApp => {
  const {
    API_BASE_URL,
    CLIENT_ID,
    CLIENT_SECRET
  } = useRuntimeConfig();

  try {
    corn.initCore(
      API_BASE_URL,
      CLIENT_ID,
      CLIENT_SECRET
    );
  } catch (e) {
    console.log(`Error initializing corn`, e);
  }
});