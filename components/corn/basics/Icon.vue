<template>
  <FontAwesomeIcon
    :icon="{iconName: iconName, prefix:iconStyle}"
    :size="size"
  />
</template>

<script lang="ts" setup>
import { IconLookup } from '@fortawesome/fontawesome-svg-core';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { PropType } from 'vue';

defineProps({
  iconName: {
    type: String as PropType<IconLookup["iconName"]>,
    required: true
  },
  iconStyle: {
    type: String as PropType<IconLookup["prefix"] >,
    default: defaultFAStyle
  },
  size: {
    type: String as PropType <`2xs` | `xs` | `sm` | `lg` | `xl` | `2xl` | `1x` | `2x` | `3x` | `4x` | `5x` | `6x` | `7x` | `8x` | `9x` | `10x` | undefined>,
    default: defaultFASize
  }
});

</script>