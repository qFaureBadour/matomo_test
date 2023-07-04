<template>
  <div class="p-12">
    <h3 class="text-3xl font-bold">
      Erreur
    </h3>

    <div
      v-if="error"
      class="py-5"
    >
      <p>
        <span class="font-bold">Error code:</span>
        <span class="font-mono ml-2">{{ error.statusCode }}</span>
      </p><p>
        <span class="font-bold">Error message:</span>
        <span class="font-mono ml-2">{{ error.message }}</span>
      </p>
    </div>

    <!-- Redirect to home page -->
    <button
      class="corn-button-primary"
      @click="handleError"
    >
      Retour
    </button>
  </div>
</template>

<script setup lang="ts">
type NuxtError = {
  url: string;
  statusCode: number;
  statusMessage: string;
  message: string;
  description: string;
  data?: any;
} | null | undefined;

defineProps<{
  error: NuxtError
}>();

// clear error and redirect to home page
const handleError = () => clearError({ redirect: Route.INDEX });
</script>
