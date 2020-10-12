<template>
  <el-dialog title="二维码" :visible.sync="dialogVisible">
    <div id="printTest">
      <QrCode :text="text" />
      <p>测试内容</p>
    </div>
    <el-button type="primary" v-print="'#printTest'">打印</el-button>
  </el-dialog>
</template>

<script>
import QrCode from '@/components/QrCode'
export default {
  components: {
    QrCode
  },
  data () {
    return {
      dialogVisible: false,
      text: ''
    }
  },
  methods: {
    init (text) {
      this.text = text
      this.dialogVisible = true
    }
  }
}
</script>

<style>
</style>
