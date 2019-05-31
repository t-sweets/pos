<template>
  <div class="container">
    <h1>
      <a class="router-link-active" @click="$router.push('/admin/')">
        <img class="header-icon" src="~assets/images/icon.png" alt="Logo">
        <span>Sweets POS Admin</span>
      </a>
    </h1>
    <el-menu
      :default-active="activeIndex"
      class="nav"
      mode="horizontal"
      v-if="auth['access-token']"
    >
      <el-submenu index="2">
        <template slot="title">{{ `ユーザー： ${user.name}` }}</template>
        <el-menu-item index="2-1" @click="isConfirmDialog = true">パスワードの変更</el-menu-item>
        <el-menu-item index="2-5" @click="confirmLogout">ログアウト</el-menu-item>
      </el-submenu>
    </el-menu>

    <el-dialog title="更新内容の確認" :visible.sync="isConfirmDialog" :append-to-body="true">
      <el-form
        ref="form"
        :model="changePassForm"
        label-width="150px"
        :label-position="labelPosition"
        size="small"
        :rules="rules"
        @submit.native.prevent="update"
      >
        <el-form-item label="Name" prop="name">
          <p class="form-text">{{ user.name }}</p>
        </el-form-item>
        <el-form-item label="Password" prop="password" required>
          <el-input
            placeholder="Please input new password"
            v-model="changePassForm.password"
            show-password
          ></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" native-type="submit">変更</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
import { mapState, mapMutations, mapActions } from "vuex";
import Cookie from "js-cookie";
export default {
  data() {
    return {
      activeIndex: "1",

      isConfirmDialog: false,
      changePassForm: {
        password: ""
      },
      rules: {
        password: [
          {
            required: true,
            message: "空のパスワードは登録できません",
            trigger: "blur"
          },
          {
            min: 8,
            message: "パスワードの長さは8文字以上にしてください",
            trigger: "blur"
          }
        ]
      }
    };
  },
  methods: {
    async confirmLogout() {
      this.$confirm("ログアウトしますか？", "Warning", {
        confirmButtonText: "OK",
        cancelButtonText: "Cancel",
        type: "warning"
      }).then(async () => {
        Cookie.remove("authdata");
        await this.logout();
        this.$router.push("/admin/login/");
      });
    },
    async update() {
      this.$refs.form.validate(async valid => {
        if (valid) {
          this.$confirm("パスワードを変更します。よろしいですか？", "Warning", {
            confirmButtonText: "OK",
            cancelButtonText: "Cancel",
            type: "warning"
          }).then(async () => {
            if (
              await this.updateUser({
                id: this.user.id,
                password: this.changePassForm.password
              })
            ) {
              this.isConfirmDialog = false;
              this.$notify({
                title: "Success",
                message: "パスワードを変更しました。",
                type: "success"
              });
            } else {
              this.$alert("パスワードを変更できませんでした", "Error", {
                confirmButtonText: "OK",
                type: "success"
              });
            }
          });
        }
      });
    },
    ...mapActions(["logout"]),
    ...mapActions("users-manager", ["updateUser"])
  },
  computed: {
    labelPosition() {
      return window.matchMedia("(max-width:1024px)").matches ? "top" : "left";
    },
    deviceScale() {
      return window.innerWidth;
    },
    ...mapState(["user"]),
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
