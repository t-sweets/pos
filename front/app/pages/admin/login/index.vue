<template>
  <el-card class="box-card">
    <div slot="header" class="clearfix">
      <span>管理者ログイン</span>
      <el-button style="float: right; padding: 3px 0" type="text">パスワードを忘れた場合</el-button>
    </div>

    <el-form
      ref="loginForm"
      :model="form"
      :rules="rule"
      label-width="120px"
      :label-position="labelPosition"
      @submit.native.prevent="onSubmit"
    >
      <el-form-item label="Name" prop="name" required>
        <el-input v-model="form.name" placeholder="Please input user name or email"></el-input>
      </el-form-item>
      <el-form-item label="Password" prop="password" required>
        <el-input placeholder="Please input password" v-model="form.password" show-password></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" native-type="submit">Login</el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>

<script>
import { mapActions, mapState } from "vuex";
import Cookie from "js-cookie";

export default {
  middleware: ["authentication"],
  data() {
    return {
      form: {
        name: "",
        password: ""
      },
      rule: {
        name: [
          {
            required: true,
            message: "LDAP名か、メールアドレスを入力してください",
            trigger: "blur"
          }
        ],
        password: [
          {
            required: true,
            message: "パスワードを入力してください",
            trigger: "blur"
          }
        ]
      }
    };
  },
  methods: {
    async onSubmit() {
      this.$refs.loginForm.validate(async valid => {
        if (valid) {
          const res = await this.login({
            userkey: this.form.name,
            password: this.form.password
          });
          if (res === true) {
            Cookie.set("auth", this.auth, { expires: 3 });
            this.$router.push("/admin/");
          } else {
            this.$alert(
              "このユーザ名・パスワードは登録されていません",
              "認証エラー",
              {
                type: "error",
                confirmButtonText: "OK"
              }
            );
          }
        } else {
          this.$message({
            type: "error",
            message: "必要項目を入力してください"
          });
        }
      });
    },
    ...mapActions(["login"])
  },
  computed: {
    labelPosition() {
      return window.matchMedia("(max-width:1024px)").matches ? "top" : "left";
    },
    device() {
      return window.matchMedia("(max-width:1024px)").matches ? "pc" : "sp";
    },
    ...mapState(["auth"])
  }
};
</script>


<style lang="scss" scoped>
.box-card {
  margin: 0 auto;
  @include pc {
    width: 70%;
  }
  @include tab {
    width: 80%;
  }
  @include sp {
    width: 100%;
  }
}
</style>
