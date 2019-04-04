<template>
  <section class="content">
    <h2>新規ユーザー登録</h2>
    <el-form
      ref="registerForm"
      :model="registerForm"
      :rules="rules"
      label-width="120px"
      @submit.native.prevent="openRegisterConfirm"
    >
      <el-form-item label="name" prop="name">
        <el-input v-model="registerForm.name"></el-input>
      </el-form-item>
      <el-form-item label="email" prop="email">
        <el-input type="email" v-model="registerForm.email"></el-input>
      </el-form-item>
      <el-form-item label="password" prop="password">
        <el-input type="password" v-model="registerForm.password" show-password autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="confirm" prop="checkpass">
        <el-input type="password" v-model="registerForm.checkpass" show-password autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="authority">
        <el-select v-model="registerForm.authority_id" placeholder="権限を選択">
          <el-option
            v-for="authority in authority_index"
            :key="authority.id"
            :label="authority.name"
            :value="authority.id"
          ></el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button style="float:right" type="primary" native-type="submit">登録内容を確認</el-button>
      </el-form-item>
    </el-form>

    <el-dialog title="ユーザー登録内容の確認" :visible.sync="isConfirmDialog">
      <el-form ref="form" label-width="200px" label-position="left" size="mini">
        <el-form-item label="ユーザー名">
          <p class="form-text">{{ registerForm.name }}</p>
        </el-form-item>
        <el-form-item label="メールアドレス">
          <p class="form-text">{{ registerForm.email }}</p>
        </el-form-item>
        <el-form-item label="パスワード">
          <p class="form-text">{{ "*".repeat(registerForm.password.length) }}</p>
        </el-form-item>
        <el-form-item label="権限">
          <p class="form-text">{{ getAuthorityName(registerForm.authority_id) }}</p>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="isConfirmDialog = false">キャンセル</el-button>
        <el-button type="primary" @click="register()">登録する</el-button>
      </span>
    </el-dialog>
  </section>
</template>

<script>
import { mapActions, mapState } from "vuex";
export default {
  middleware: ["authentication"],
  data() {
    var validatePass = (rule, value, callback) => {
      if (value === "") {
        callback(new Error("Please input the password"));
      } else {
        if (this.registerForm.checkpass !== "") {
          this.$refs.registerForm.validateField("checkpass");
        }
        callback();
      }
    };
    var validatePass2 = (rule, value, callback) => {
      if (value === "") {
        callback(new Error("Please input the password again"));
      } else if (value !== this.registerForm.password) {
        callback(new Error("Two inputs don't match!"));
      } else {
        callback();
      }
    };
    return {
      registerForm: {
        name: "",
        email: "",
        password: "",
        checkpass: "",
        authority_id: 4
      },
      rules: {
        name: [
          {
            required: true,
            message: "Please input user name",
            trigger: "blur"
          },
          {
            min: 3,
            max: 10,
            message: "Length should be 3 to 10",
            trigger: "blur"
          }
        ],
        email: [
          {
            required: true,
            message: "Please input email address",
            trigger: "blur"
          },
          {
            type: "email",
            message: "Please input correct email address",
            trigger: ["blur", "change"]
          }
        ],
        password: [
          { required: true, validator: validatePass, trigger: "blur" },
          {
            min: 1,
            message: "Length should be 1 more over.",
            trigger: "blur"
          }
        ],
        checkpass: [
          { required: true, validator: validatePass2, trigger: "blur" }
        ]
      },
      isConfirmDialog: false
    };
  },
  methods: {
    getAuthorityName(id) {
      return this.authority_index.length > 0
        ? this.authority_index[id - 1].name
        : "";
    },
    openRegisterConfirm() {
      if (this.$refs.registerForm.validate()) {
        this.isConfirmDialog = true;
      }
    },
    register() {
      this.$confirm("ユーザーを登録しますか？", "Warning", {
        confirmButtonText: "登録",
        cancelButtonText: "キャンセル",
        type: "warning"
      }).then(async () => {
        const loading = this.$loading({ lock: true });
        if (await this.createUser(this.registerForm)) {
          this.$notify({
            title: "登録成功",
            message: "新規ユーザーを登録しました",
            type: "success"
          });
          this.formReset();
          this.isConfirmDialog = false;
        } else {
          this.$alert("ユーザーの登録に失敗しました", "Error", {
            confirmButtonText: "OK",
            type: "error"
          });
        }
        loading.close();
      });
    },
    formReset() {
      this.registerForm = {
        name: "",
        email: "",
        password: "",
        checkpass: "",
        authority_id: 4
      };
    },
    ...mapActions("users-manager", ["getUsers", "createUser"])
  },
  computed: {
    labelPosition() {
      return window.matchMedia("(max-width:1024px)").matches ? "top" : "left";
    },
    deviceType() {
      return window.matchMedia("(max-width:1024px)").matches;
    },
    ...mapState(["authority_index"]),
    ...mapState("users-manager", ["users"])
  },
  async mounted() {
    if ((await this.getUsers()) === false) {
      this.$alert("ユーザー情報の取得に失敗しました", "Error", {
        confirmButtonText: "OK",
        type: "error"
      });
    }
  }
};
</script>

<style lang="scss" scoped>
.content {
  h2 {
    font-size: 28px;
    font-weight: 400;
    color: #1f2f3d;
    margin: 0;
    margin-bottom: 20px;
    border-bottom: 2px solid #409eff;
  }
  .inline-input {
    @include pc {
      width: 500px;
    }
    @include tab {
      width: 300px;
    }
    @include sp {
      width: 100%;
    }
  }
}
</style>

<style lang="scss">
.content {
  table {
    tbody {
      tr {
        &.over-char-hidden {
          td {
            div {
              overflow: hidden;
              text-overflow: ellipsis;
              white-space: nowrap;
            }
          }
        }
      }
    }
  }
}
</style>
