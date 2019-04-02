<template>
  <div class="container">
    <h1>
      <a class="router-link-active" @click="$router.push('/')">
        <img class="header-icon" src="~assets/images/icon.png" alt="Logo">
        <span>Sweets POS Admin</span>
      </a>
    </h1>
    <el-menu
      :default-active="activeIndex"
      class="nav"
      mode="horizontal"
      @select="handleSelect"
      v-if="auth['access-token']"
    >
      <el-submenu index="2">
        <template slot="title">ユーザー情報</template>
        <el-menu-item index="2-5" @click="confirmLogout">ログアウト</el-menu-item>
      </el-submenu>
    </el-menu>
  </div>
</template>

<script>
import { mapState, mapMutations, mapActions } from "vuex";
import Cookie from "js-cookie";
export default {
  data() {
    return {
      activeIndex: "1",
      activeIndex2: "1"
    };
  },
  methods: {
    handleSelect(key, keyPath) {
      console.log(key, keyPath);
    },
    async confirmLogout() {
      this.$confirm("ログアウトしますか？", "Warning", {
        confirmButtonText: "OK",
        cancelButtonText: "Cancel",
        type: "warning"
      }).then(async () => {
        Cookie.remove("auth");
        await this.logout();
        this.$router.push("/admin/login/");
      });
    },
    ...mapActions(["logout"])
  },
  computed: {
    deviceScale() {
      return window.innerWidth;
    },
    ...mapState(["auth"])
  }
};
</script>


<style lang="scss" scoped>
.container {
  height: 100%;
  box-sizing: border-box;
  padding: 0;
  margin: 0 auto;
  border-bottom: 1px solid #dcdfe6;

  h1 {
    margin: 0;
    float: left;
    @include pc {
      font-size: 32px;
      font-weight: 400;
      line-height: 80px;
    }
    a {
      color: #333;
      text-decoration: none;
      display: block;
      img {
        &.header-icon {
          float: left;
          height: 60px;
          margin-right: 10px;
        }
      }
      span {
        @include sp {
          display: none;
        }
      }
    }
  }

  ul {
    float: right;
    height: 100%;
    line-height: 80px;
    background: transparent;
    padding: 0;
    margin: 0;

    li {
      @include sp {
        margin-left: 6px;
        padding: 0px;
        font-size: 12px;
      }
    }

    &.el-menu.el-menu--horizontal {
      border-bottom: none;
    }
  }
}
</style>
