<template>
  <section class="content">
    <h2>ユーザー情報変更</h2>
    <el-table
      :data="users"
      style="width: 100%"
      ref="queueList"
      row-class-name="over-char-hidden"
      height="300"
      size="mini"
    >
      <el-table-column label="ユーザー名" sortable prop="name"></el-table-column>
      <el-table-column label="メールアドレス" prop="email"></el-table-column>
      <el-table-column label="権限" sortable prop="authority_id">
        <template slot-scope="props">
          <p class="form-text">{{ getAuthorityName(props.row.authority_id) }}</p>
        </template>
      </el-table-column>
      <el-table-column>
        <template slot-scope="props">
          <el-button plain type="primary" @click="openEditDialog(props.row)" size="mini">編集</el-button>
          <el-button plain type="danger" size="mini" @click="openDeleteDialog(props.row)">削除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog title="ユーザー情報変更" :visible.sync="isEditDialog">
      <el-form
        ref="editForm"
        :model="editForm"
        :rules="rules"
        label-width="120px"
        @submit.native.prevent="openEditConfirm"
      >
        <el-form-item label="name" prop="name">
          <el-input v-model="editForm.name"></el-input>
        </el-form-item>
        <el-form-item label="email" prop="email">
          <el-input type="email" v-model="editForm.email"></el-input>
        </el-form-item>
        <el-form-item label="authority">
          <el-select v-model="editForm.authority_id" placeholder="権限を選択">
            <el-option
              v-for="authority in authority_index"
              :key="authority.id"
              :label="authority.name"
              :value="authority.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="pass change">
          <el-switch v-model="isChangePassword"></el-switch>
        </el-form-item>
        <el-form-item label="password" v-if="isChangePassword">
          <el-input
            placeholder="Please input new password"
            v-model="editForm.password"
            show-password
          ></el-input>
        </el-form-item>
        <el-form-item>
          <el-button style="float:right" @click="isEditDialog = false">キャンセル</el-button>
          <el-button style="float:right" type="primary" native-type="submit">登録内容を確認</el-button>
        </el-form-item>
      </el-form>
      <el-dialog title="ユーザー情報変更の確認" :visible.sync="isConfirmDialog" append-to-body>
        <el-form ref="form" label-width="200px" label-position="left" size="mini">
          <el-form-item label="ユーザー名">
            <p class="form-text">{{ editForm.name }}</p>
          </el-form-item>
          <el-form-item label="メールアドレス">
            <p class="form-text">{{ editForm.email }}</p>
          </el-form-item>
          <el-form-item
            label="パスワード"
            v-if="isChangePassword && editForm.password && editForm.password.length > 0"
          >
            <p class="form-text">{{ "*".repeat(editForm.password.length) }}</p>
          </el-form-item>
          <el-form-item label="権限">
            <p class="form-text">{{ getAuthorityName(editForm.authority_id) }}</p>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="isConfirmDialog = false">キャンセル</el-button>
          <el-button type="primary" @click="edit()">更新する</el-button>
        </span>
      </el-dialog>
    </el-dialog>

    <el-dialog title="ユーザー削除の確認" :visible.sync="isDeleteDialog" append-to-body>
      <el-form ref="form" label-width="200px" label-position="left" size="mini">
        <el-form-item label="ユーザー名">
          <p class="form-text">{{ editForm.name }}</p>
        </el-form-item>
        <el-form-item label="メールアドレス">
          <p class="form-text">{{ editForm.email }}</p>
        </el-form-item>
        <el-form-item label="権限">
          <p class="form-text">{{ getAuthorityName(editForm.authority_id) }}</p>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="isDeleteDialog = false">キャンセル</el-button>
        <el-button type="danger" @click="execDelete">削除する</el-button>
      </span>
    </el-dialog>
  </section>
</template>

<script>
import { mapActions, mapState } from "vuex";
export default {
  middleware: ["authentication"],
  data() {
    return {
      editForm: {
        id: 0,
        name: "",
        email: "",
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
        ]
      },
      isDeleteDialog: false,
      isEditDialog: false,
      isConfirmDialog: false,
      isChangePassword: false
    };
  },
  methods: {
    getAuthorityName(id) {
      return this.authority_index.length > 0
        ? this.authority_index[id - 1].name
        : "";
    },

    openEditDialog(user) {
      this.editForm = {
        ...user
      };
      this.isEditDialog = true;
      this.isConfirmDialog = false;
    },

    openEditConfirm() {
      if (this.$refs.editForm.validate()) {
        this.isConfirmDialog = true;
      }
    },

    edit() {
      this.$confirm("ユーザー情報を更新しますか？", "Warning", {
        confirmButtonText: "更新",
        cancelButtonText: "キャンセル",
        type: "warning"
      }).then(async () => {
        const loading = this.$loading({ lock: true });
        if (await this.updateUser(this.editForm)) {
          this.$notify({
            title: "更新成功",
            message: "ユーザー情報を更新しました",
            type: "success"
          });
          this.formReset();
          this.isEditDialog = false;
          this.isConfirmDialog = false;
        } else {
          this.$alert("ユーザー情報の更新に失敗しました", "Error", {
            confirmButtonText: "OK",
            type: "error"
          });
        }
        loading.close();
      });
    },

    openDeleteDialog(user) {
      this.editForm = {
        ...user
      };
      this.isChangePassword = false;
      this.isDeleteDialog = true;
    },
    execDelete(id) {
      this.$confirm("本当に消去しますか？", "Warning", {
        confirmButtonText: "消去",
        cancelButtonText: "キャンセル",
        type: "warning"
      }).then(async () => {
        const loading = this.$loading({ lock: true });
        if (await this.deleteUser(this.editForm.id)) {
          this.$notify({
            title: "削除成功",
            message: "ユーザー情報を消去しました",
            type: "success"
          });
          this.formReset();
          this.isDeleteDialog = false;
        } else {
          this.$alert("ユーザーの削除に失敗しました", "Error", {
            confirmButtonText: "OK",
            type: "error"
          });
        }
        loading.close();
      });
    },

    formReset() {
      this.editForm = {
        name: "",
        email: "",
        authority_id: 4
      };
    },

    ...mapActions("users-manager", ["getUsers", "updateUser", "deleteUser"])
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
