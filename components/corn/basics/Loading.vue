<template>
  <div class="flex items-center justify-center w-full h-full">
    <div class="corn-spinner">
      <div></div><div></div>
    </div>
  </div>
</template>

<style lang="scss" scoped>

.corn-spinner {
  display: inline-block;
  position: relative;
  width: 80px;
  height: 80px;
  align-items: center;
  justify-content: center;
}
.corn-spinner div {
  position: absolute;
  border-width: 4px;
  border-style: solid;
  @apply border-gray-500;
  opacity: 1;
  border-radius: 50%;
  animation: cornSpinner 1s cubic-bezier(0, 0.2, 0.8, 1) infinite;
transform-origin: center center;
}
.corn-spinner div:nth-child(2) {
  animation-delay: -0.5s;
}
@keyframes cornSpinner {
  0% {
    top: 36px;
    left: 36px;
    width: 0;
    height: 0;
    opacity: 0;
  }
  5% {
    top: 36px;
    left: 36px;
    width: 0;
    height: 0;
    opacity: 1;
  }
  100% {
    top: 0px;
    left: 0px;
    width: 72px;
    height: 72px;
    opacity: 0;
  }
}
</style>
