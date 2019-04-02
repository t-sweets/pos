<template>
  <el-container>
    <el-header>
      <main-header/>
    </el-header>
    <el-container>
      <el-aside v-if="auth['access-token']">
        <main-aside/>
      </el-aside>
      <el-main :class="{ 'is-aside': auth['access-token']}">
        <nuxt/>
      </el-main>
    </el-container>
  </el-container>
</template>

<script>
import MainHeader from "@/components/assets/MainHeader";
import MainAside from "@/components/assets/MainAside";
import { mapState, mapActions } from "vuex";
export default {
  methods: {
    ...mapActions(["getAuthorities", "getUserData"])
  },
  components: {
    MainHeader,
    MainAside
  },
  computed: {
    deviceScale() {
      return window.innerWidth;
    },
    ...mapState(["auth"])
  },
  async mounted() {
    if (this.auth["access-token"] && this.auth.uid && this.auth.client) {
      if ((await this.getAuthorities()) && (await this.getUserData())) {
      } else {
        // エラー時のメッセージ
      }
    }
  }
};
</script>


<style lang="scss">
html {
  font-family: "Source Sans Pro", -apple-system, BlinkMacSystemFont, "Segoe UI",
    Roboto, "Helvetica Neue", Arial, sans-serif;
  font-size: 16px;
  word-spacing: 1px;
  -ms-text-size-adjust: 100%;
  -webkit-text-size-adjust: 100%;
  -moz-osx-font-smoothing: grayscale;
  -webkit-font-smoothing: antialiased;
  box-sizing: border-box;
}

*,
*:before,
*:after {
  box-sizing: border-box;
  margin: 0;
}

.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}
.clearfix:after {
  clear: both;
}

form {
  .el-form-item {
    label {
      @include sp {
        padding: 0px !important;
      }
    }
  }
}

.product-image-uploader {
  .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    &:hover {
      border-color: #409eff;
    }
  }
  .product-image-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 178px;
    height: 178px;
    line-height: 178px;
    text-align: center;
  }
  .product-image {
    width: 178px;
    height: 178px;
    display: block;
  }
}
</style>

<style lang="scss" scoped>
header {
  position: fixed;
  width: 100%;
  left: 0;
  top: 0;
  z-index: 1500;
  background: #fff;
}
main,
aside {
  padding: 0;
  margin-top: 80px;
}

main {
  &.is-aside {
    @include pc {
      margin-left: 250px;
      margin-right: 50px;
    }
    @include tab {
      margin-left: 100px;
      margin-right: 50px;
    }
    @include sp {
      margin-left: 65px;
      margin-right: 0px;
    }
  }
}

aside {
  position: fixed;
}
</style>
