<template>
  <section class="content">
    <h2>ユーザーリスト</h2>
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
    </el-table>
  </section>
</template>

<script>
import { mapActions, mapState } from "vuex";
export default {
  middleware: ["authentication"],
  data() {
    return {
      isSelected: false,
      isConfirmDialog: false
    };
  },
  methods: {
    getAuthorityName(id) {
      return this.authority_index.length > 0
        ? this.authority_index[id - 1].name
        : "";
    },
    ...mapActions("users-manager", ["getUsers"])
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
