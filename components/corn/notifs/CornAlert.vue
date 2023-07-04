<template>
  <div
    class="rounded-corn border-l-4 p-4  shadow-md w-full mb-3"
    :class="`bg-${alertType}-50  border-${alertType}-400`"
  >
    <div class="flex justify-between items-center">
      <div class="flex ">
        <div class="flex-shrink-0">
          <FontAwesomeIcon
            v-if="icon && icon.length > 0"
            :icon="icon"
            :class="`text-${alertType}-500`"
          />
        </div>
        <div class="ml-4 ">
          <h3
            v-if="title"
            class="text-sm mb-1 font-medium "
            :class="`text-${alertType}-800`"
          >
            {{ title }}
          </h3>
          <div
            v-if="content"
            class=" text-sm "
            :class="`text-${alertType}-700`"
          >
            <p>{{ content }}</p>
          </div>
        </div>
      </div>
      <div v-if="autoClose === false || autoClose === 0">
        <Icon
          iconName="circle-xmark"
          :iconStyle="IconStyle.SOLID"
          :class="`text-${alertType}-300`"
          class="p-3 cursor-pointer"
          size="lg"
          @click="() => dismissAlertById(id)"
        />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import corn from '~~/corn';

const props = defineProps({
  id: {
    type: Number,
    required: true
  },
  title: {
    type: String
  },
  content: {
    type: String,
    required: true
  },
  alertType: {
    type: String,
    default: `danger`
  },
  autoClose: {
    type: [ Boolean, Number ]
  }
});

const icon = getInfosFromAlertType();

function getInfosFromAlertType(): string {
  let icon = `info`;
  switch (props.alertType) {
    case `info`: {
      icon = `fa-solid fa-circle-info`;
      break;
    }
    case `warning`: {
      icon = `fa-solid fa-circle-exclamation`;
      break;
    }
    case `danger`: {
      icon = `fa-solid fa-triangle-exclamation`;
      break;
    }
    case `success`: {
      icon = `fa-solid fa-circle-check`;
      break;
    }
    default: {
      icon = ``;
    }
  }
  return icon;
}

function dismissAlertById(id: number) {
  corn.alerts.dismissById(id);
}

</script>
