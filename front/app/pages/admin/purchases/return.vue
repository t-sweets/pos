<template>
  <section class="content">
    <h2>全返品</h2>
    <el-form
      ref="form"
      v-model="searchForm"
      label-width="100px"
      :label-position="labelPosition"
      @submit.native.prevent="searchSumbit"
      size="small"
      :inline="!deviceType"
    >
      <el-form-item label="レシートID">
        <el-input class="inline-input" type="number" v-model="searchForm.uuid"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button style="float:right;" type="primary" native-type="submit">検索</el-button>
      </el-form-item>
    </el-form>
    <hr>
    <el-form
      ref="form"
      v-if="purchase.id"
      label-width="100px"
      :label-position="labelPosition"
      size="mini"
    >
      <el-form-item label="レシートID">
        <p class="form-text">{{ purchase.id }}</p>
      </el-form-item>
      <el-form-item label="決済日時">
        <p class="form-text">{{ dateFormat(new Date(purchase.created_at)) }}</p>
      </el-form-item>
      <el-form-item label="購入商品">
        <el-table
          :data="purchase.purchase_items"
          style="width: 100%"
          ref="queueList"
          row-class-name="over-char-hidden"
          height="300"
          size="mini"
          show-summary
          :summary-method="getSummaries"
        >
          <el-table-column label="商品名" prop="product.name"></el-table-column>
          <el-table-column label="JAN" prop="product.jan"></el-table-column>
          <el-table-column label="金額" sortable prop="product.price" width="100"></el-table-column>
          <el-table-column label="個数" sortable prop="quantity" width="100"></el-table-column>
        </el-table>
      </el-form-item>
      <el-form-item label="支払金額">
        <p class="form-text">{{ totalPrice }}</p>
      </el-form-item>
      <el-form-item label="決済方法">
        <p class="form-text">{{ paymentMethod(purchase.payment_method_id) }}</p>
      </el-form-item>

      <el-form-item style="float:right;">
        <el-button size="small" type="primary" plain @click="isConfirmDialog=true">返品手続き</el-button>
      </el-form-item>
    </el-form>

    <el-dialog
      title="返品手続き"
      :visible.sync="isConfirmDialog"
      width="90%"
      :close-on-click-modal="false"
    >
      <span>返品される商品のJANコード・個数を確認してください。</span>
      <el-table
        :data="purchase.purchase_items"
        style="width: 100%"
        ref="queueList"
        row-class-name="over-char-hidden"
        height="300"
        size="small"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column label="商品名" prop="product.name"></el-table-column>
        <el-table-column label="JAN" prop="product.jan"></el-table-column>
        <el-table-column label="金額" sortable prop="product.price" width="100"></el-table-column>
        <el-table-column label="個数" sortable prop="quantity" width="100"></el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
        <el-button @click="isConfirmDialog = false">キャンセル</el-button>
        <el-button
          type="primary"
          :disabled="verifiedItems.length !== purchase.purchase_items.length"
          @click="preExecReturn"
        >確認</el-button>
      </span>
    </el-dialog>
  </section>
</template>

<script>
import { mapActions, mapState, mapGetters } from "vuex";
export default {
  middleware: ["authentication"],
  data() {
    return {
      searchForm: {
        uuid: ""
      },
      purchase: {
        id: null,
        created_at: null,
        purchase_items: [],
        payment_method_id: null,
        payment_uuid: ""
      },
      verifiedItems: [],
      isConfirmDialog: false
    };
  },
  methods: {
    /**
     * レシートのUUIDから検索
     */
    async searchSumbit() {
      if (this.searchForm.uuid == "") return false;
      const purchase = await this.getPurchases(this.searchForm.uuid);
      if (purchase) {
        if (purchase.deleted) {
          this.$alert("既に返品処理された決済です。", "Error", {
            confirmButtonText: "OK",
            type: "error"
          });
        } else {
          this.purchase = {
            ...purchase
          };
        }
        this.searchForm.uuid = "";
      } else {
        this.$alert("該当する決済が見つかりませんでした", "Error", {
          confirmButtonText: "OK",
          type: "error"
        });
      }
    },

    /**
     * サマリーメソッド
     */
    getSummaries(param) {
      const { columns, data } = param;
      const sums = [];
      columns.forEach((column, index) => {
        if (index === 0) {
          sums[index] = "合計";
          return;
        } else {
          let values = data.map(item => Number(item[column.property]));
          if (column.property == "product.price") {
            values = data.map(item => Number(item.price * item.quantity));
          }

          if (!values.every(value => isNaN(value))) {
            sums[index] = values.reduce((prev, curr) => {
              const value = Number(curr);
              if (!isNaN(value)) {
                return prev + curr;
              } else {
                return prev;
              }
            }, 0);
          } else {
            sums[index] = "";
          }
        }
      });

      return sums;
    },

    handleSelectionChange(val) {
      this.verifiedItems = val;
    },

    paymentMethod(id) {
      return this.payment_method[id - 1].name;
    },

    /**
     * POSへの返品処理の前に、前実行（各種支払い方法への返品）
     */
    async preExecReturn() {
      let result;
      this.$confirm("返品処理を行いますか？", "Warning", {
        confirmButtonText: "実行",
        cancelButtonText: "キャンセル",
        type: "warning"
      }).then(async _ => {
        switch (this.paymentMethod(this.purchase.payment_method_id)) {
          case "t-pay":
            if (!this.isServiceable && (await this.getApiToken()) === false) {
              this.$alert(
                "提携決済サービスとの接続に失敗しました。当該サービスを利用した決済の返品処理ができない場合があります。",
                "Connection Error [tpay]",
                {
                  confirmButtonText: "OK",
                  type: "error"
                }
              );
              return false;
            }
            /**
             * T-Payサーバーと通信して処理を待つ
             */
            const responce = await this.refund(this.purchase.payment_uuid);
            if (responce === true) {
              result = true;
            } else {
              // エラーの場合メッセージをだす
              let err_message = "不明なエラーが発生しました。";
              switch (responce) {
                case 400:
                  err_message = "既にキャンセルされた決済です";
                  break;
                case 404:
                  err_message =
                    "決済情報が見つかりませんでした。データベース情報を確認してください。";
                  break;
              }
              this.$alert(err_message, "", {
                confirmButtonText: "OK",
                type: "error"
              });
              return false;
            }
            break;
          case "cash":
            result = true;
            break;
        }
        if (result === true) {
          await this.execReturn();
        }
      });
    },

    /**
     * 返品を実行
     */
    async execReturn() {
      if (await this.purchasesCancel(this.purchase.id)) {
        this.$alert("返品処理が完了しました", "success", {
          confirmButtonText: "OK",
          type: "success"
        }).then(() => {
          this.isConfirmDialog = false;
          this.formReset();
        });
      }
    },

    formReset() {
      this.purchase = {
        id: null,
        created_at: null,
        purchase_items: [],
        payment_method_id: null,
        payment_uuid: ""
      };
      this.verifiedItems = [];
    },

    ...mapActions("tpay", ["getApiToken", "refund"]),
    ...mapActions("purchases-manager", [
      "getPurchases",
      "getPaymentMethod",
      "purchasesCancel"
    ])
  },
  computed: {
    labelPosition() {
      return window.matchMedia("(max-width:1024px)").matches ? "top" : "left";
    },
    deviceType() {
      return window.matchMedia("(max-width:1024px)").matches;
    },
    totalPrice() {
      let price = 0;
      this.purchase.purchase_items.forEach(item => {
        price += item.price * item.quantity;
      });
      return price;
    },
    ...mapState("purchases-manager", ["payment_method"]),
    ...mapGetters("tpay", ["isServiceable"])
  },
  async mounted() {
    if ((await this.getPaymentMethod()) === false) {
      this.$alert("商品情報の取得に失敗しました", "Error", {
        confirmButtonText: "OK",
        type: "error"
      });
      return false;
    }
    if ((await this.getApiToken()) === false) {
      this.$alert(
        "提携決済サービスとの接続に失敗しました。当該サービスを利用した決済の返品処理ができない場合があります。",
        "Connection Error [tpay]",
        {
          confirmButtonText: "OK",
          type: "error"
        }
      );
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
