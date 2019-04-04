<template>
  <section class="content">
    <h2>ジャーナル照会</h2>
    <el-form
      ref="form"
      :model="searchForm"
      label-width="100px"
      :label-position="labelPosition"
      @submit.native.prevent="searchSumbit"
      size="small"
      :inline="!deviceType"
    >
      <el-form-item label="レシートID">
        <el-input class="inline-input" v-model="searchForm.uuid"></el-input>
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
          <el-table-column label="商品名" width="400">
            <template slot-scope="props">
              <p class="form-text">{{ props.row.product.name }}</p>
            </template>
          </el-table-column>
          <el-table-column label="金額" sortable prop="product.price"></el-table-column>
          <el-table-column label="個数" sortable prop="quantity"></el-table-column>
        </el-table>
      </el-form-item>
      <el-form-item label="支払金額">
        <p class="form-text">{{ totalPrice }}</p>
      </el-form-item>
      <el-form-item label="決済方法">
        <p class="form-text">{{ paymentMethod(purchase.payment_method_id) }}</p>
      </el-form-item>
    </el-form>
  </section>
</template>

<script>
import { mapActions, mapState } from "vuex";
export default {
  middleware: ["authentication"],
  data() {
    return {
      searchForm: {
        uuid: ""
      },
      purchase: {
        created_at: null,
        purchase_items: [],
        payment_method_id: null
      },
      queueData: [],
      isSelected: false,
      isConfirmDialog: false
    };
  },
  methods: {
    /**
     * レシートのUUIDから検索
     */
    async searchSumbit() {
      if (this.searchForm.uuid == "") return false;
      this.purchase = await this.getPurchases(this.searchForm.uuid);
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
            sums[index] = "N/A";
          }
        }
      });

      return sums;
    },

    paymentMethod(id) {
      return this.payment_method[id - 1].name;
    },

    ...mapActions("purchases-manager", ["getPurchases", "getPaymentMethod"])
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
    ...mapState("purchases-manager", ["payment_method"])
  },
  async mounted() {
    if ((await this.getPaymentMethod()) === false) {
      this.$alert("商品情報の取得に失敗しました", "Error", {
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
