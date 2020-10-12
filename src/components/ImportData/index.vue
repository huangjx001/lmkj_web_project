<!--
 * @Descripttion: 导入按钮
 * @version:
 * @Author: Mr.What
 * @Date: 2020-06-16 17:37:57
 * @LastEditors: Mr.What
 * @LastEditTime: 2020-06-17 11:52:48
-->
<template>
  <div class="file-import-container">
    <el-button @click="clickHandle" :style="{backgroundColor: bgColor, borderColor: bgColor}" type="primary" :class="{uploading: loadingStatus}" ref="fiButton" :icon="icon" v-waves>{{text}}</el-button>
    <transition enter-active-class="animated zoomIn faster" leave-active-class="animated zoomOut faster">
      <div class="progress-bar" :style="{width: pW + 'px'}" v-show="loadingStatus">
        <div class="progress" :style="{width: pValue * pW + 'px'}"></div>
      </div>
    </transition>
    <input type="file" :accept="accept + ',' + accept.toUpperCase()" ref="file" :multiple="multiple" @change="changeHandle" style="display:none;">
  </div>
</template>

<script>
export default {
  props: {
    btuuonText: {
      type: String,
      default: '文件导入'
    },
    accept: {
      type: String,
      default: '.doc,.pdf,.xls,.xlsx'
    },
    multiple: {
      type: Boolean,
      default: false
    },
    size: {
      type: [String, Number],
      default: 10
    },
    url: {
      type: String,
      default: '' // /spring-processweb/xlkjSubject/importExcel
    },
    formData: {
      type: Object,
      default: () => {
        return {}
      }
    }
  },
  components: {},
  data () {
    return {
      loadingStatus: false,
      text: this.btuuonText,
      pValue: 0,
      pW: 0,
      pH: 0,
      bgColor: null,
      icon: 'el-icon-upload'
    }
  },
  created () { },
  mounted () {
    this.$nextTick(() => {
      this.pH = this.$refs.fiButton.$el.offsetHeight
      this.pW = this.$refs.fiButton.$el.offsetWidth
    })
  },
  computed: {},
  watch: {},
  methods: {
    clickHandle () {
      if (this.loadingStatus) {
        this.$message.info('文件上传处理中，请稍后操作...')
        return
      }
      if (!this.url) {
        this.$message.error('未指定文件上传路径!')
        return
      }
      this.$refs.file.click()
    },
    changeHandle () {
      let fileList = Array.from(this.$refs.file.files)
      if (fileList.length > 0) {
        fileList.map(res => {
          if (res.size > (this.size * 1024 * 1024)) {
            this.$message.error('文件大小超出限制，当前限制为' + this.size + 'M')
            return
          }
          this.requestHandle(res)
        })
      }
    },
    async requestHandle (file) {
      this.changeLoadStaus(true)
      let formData = new FormData()
      formData.append('file', file)
      for (let item in this.formData) {
        formData.append(item, this.formData[item])
      }
      await this.$http({
        url: this.$http.adornUrl(this.url),
        method: 'POST',
        data: formData,
        headers: {
          'Content-Type': 'multipart/form-data',
          'token': this.$cookie.get('token')
        },
        onUploadProgress: progressEvent => {
          this.pValue = progressEvent.loaded / progressEvent.total
        }
      }).then(({ data }) => {
        if (data && data.code === 0) {
          this.$message({
            type: 'success',
            duration: 1500,
            message: '上传成功!'
          })
          this.changeBG(true)
          this.$emit('success')
        } else {
          this.changeBG(false)
          this.$message.error(data.msg || '操作失败')
        }
      }).catch((err) => {
        this.changeBG(false)
        this.$message.error(err.message)
      })
      this.changeLoadStaus(false)
    },
    changeLoadStaus (status) {
      this.loadingStatus = status
      this.pValue = 0
      if (status) {
        this.icon = 'el-icon-loading'
      } else {
        this.$refs.file.value = ''
      }
    },
    changeBG (status) {
      if (status) {
        this.bgColor = '#67C23A'
        this.text = '上传成功'
        this.icon = 'el-icon-success'
      } else {
        this.bgColor = '#F56C6C'
        this.text = '上传失败'
        this.icon = 'el-icon-error'
      }
      setTimeout(() => {
        this.icon = 'el-icon-upload'
        this.bgColor = null
        this.text = this.btuuonText
      }, 4000)
    }
  }
}
</script>

<style lang="scss">
.file-import-container {
  display: inline-block;
  position: relative;
  .progress-bar {
    position: absolute;
    left: 0;
    height: 3px;
    bottom: -7px;
    background: #c1c1c1;
    .progress {
      height: 100%;
      background: #2c78bb;
      transition: 0.3s width;
    }
  }
  .el-button {
    transition: 0.5s background-color, 0.5s border-color;
  }
  .uploading {
    background-size: 25px 25px;
    background-image: linear-gradient(
      45deg,
      rgba(255, 255, 255, 0.15) 25%,
      transparent 25%,
      transparent 50%,
      rgba(255, 255, 255, 0.15) 50%,
      rgba(255, 255, 255, 0.15) 75%,
      transparent 75%,
      transparent
    );
    animation: animate-positive 15s infinite linear;
  }
  @keyframes animate-positive {
    from {
      background-position-x: 0;
    }
    to {
      background-position-x: 600px;
    }
  }
}
</style>
