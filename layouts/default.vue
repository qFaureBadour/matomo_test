<template>
  <div>
    <!-- TOPBAR -->
    <div class="flex w-full p-8 justify-end items-center">
      <Popper content="Se déconnecter" openDelay="400" placement="top" hover>
        <button class="corn-button-outline-secondary" @click="() => { corn.auth.logOut() }">
          <Icon iconName="arrow-right-to-arc" class="rotate-180"/>
        </button>
      </Popper>
    </div>
    
    <NuxtPage />
  </div>
</template>