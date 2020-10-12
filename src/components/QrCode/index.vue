<template>
  <div class="qr-code-container">
    <vue-qr :logoSrc="logoSrc" :text="text" :size="200"></vue-qr>
  </div>
</template>

<script>
import vueQr from 'vue-qr'
export default {
  props: {
    logoSrc: { // 二维码中间的logo
      type: String,
      default: ''
    },
    text: { // 二维码内容
      type: String,
      default: '测试内容'
    }
  },
  components: {
    vueQr
  }
}
</script>

<style lang="scss">
.qr-code-container {
}
</style>
