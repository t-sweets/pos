<template>
  <section class="content">
    <h2>商品別売上</h2>
    <div class="aggregation-target">
      <span>分析対象</span>
      <el-date-picker
        v-model="searchForm.date"
        type="daterange"
        unlink-panels
        range-separator="To"
        start-placeholder="Start date"
        end-placeholder="End date"
        size="small"
        :picker-options="pickerOptions"
        @change="searchExec"
      ></el-date-picker>
    </div>

    <el-table
      class="manage-list"
      :data="dateForTable"
      :default-sort="{prop: 'period', order: 'ascending'}"
      style="width: 100%"
    >
      <el-table-column prop="period" label="商品名" sortable>
        <template slot-scope="scope">
          <p>{{toStrDate(scope.row.period)}}</p>
        </template>
      </el-table-column>
      <el-table-column prop="sales" label="売上"></el-table-column>
      <el-table-column prop="counts" label="会計数"></el-table-column>
      <el-table-column prop="avarage" label="会計単価">
        <template slot-scope="scope">
          <p>¥{{Math.round(scope.row.avarage)}}</p>
        </template>
      </el-table-column>
      <el-table-column prop="quantity" label="販売商品数"></el-table-column>
      <el-table-column label="詳細">
        <template slot-scope="scope">
          <el-button type="text" size="mini" @click="showDetialDialog(scope.row.period)">詳細</el-button>
        </template>
      </el-table-column>
    </el-table>
  </section>
</template>

<script>
import { mapGetters, mapActions, mapState } from "vuex";

export default {
  data() {
    return {
      searchForm: {
        date: [
          new Date(new Date().getTime() - 3600 * 1000 * 24 * 7),
          new Date()
        ]
      },
      pickerOptions: {
        shortcuts: [
          {
            text: "先週",
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
              picker.$emit("pick", [start, end]);
            }
          },
          {
            text: "先月",
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
              picker.$emit("pick", [start, end]);
            }
          },
          {
            text: "過去３カ月",
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
              picker.$emit("pick", [start, end]);
            }
          }
        ]
      }
    };
  },
  methods: {
    async searchExec() {
      if (this.searchForm.date.length < 2) return false;
      if (
        await this.getProductSales({
          from: this.searchForm.date[0],
          to: this.searchForm.date[1]
        })
      ) {
        console.log(this.product_sales);
      }
    },

    ...mapActions("sales-manager", ["getProductSales"]),
    ...mapActions("products-manager", ["getProducts"])
  },
  computed: {
    dateForTable() {
      let data = [];

      this.product_sales.forEach(item => {
        let added = false;
        // すでにlistに存在すれば
        data.some(column => {
          const period_date = new Date(column.period),
            created_date = new Date(item.created_at);
          if (
            (this.searchForm.target == "time" &&
              period_date.getHours() == created_date.getHours()) ||
            (this.searchForm.target == "date" &&
              period_date.getDate() == created_date.getDate()) ||
            (this.searchForm.target == "month" &&
              period_date.getMonth() == created_date.getMonth()) ||
            (this.searchForm.target == "year" &&
              period_date.getFullYear() == created_date.getFullYear())
          ) {
            column.sales += item.sales;
            column.counts++;
            column.avarage = column.sales / column.counts;
            item.purchase_items.forEach(purchase_items => {
              column.quantity += purchase_items.quantity;
            });

            added = true;
          } else return false;
        });
        // listになければ新規登録
        if (!added) {
          let firstData = {
            period: item.created_at,
            sales: item.sales,
            counts: 1,
            avarage: item.sales / 1,
            quantity: 0,
            payment_method: new Array(this.payment_method.length)
          };
          item.purchase_items.forEach(purchase_items => {
            firstData.quantity += purchase_items.quantity;
          });
          for (let i = 0; i < firstData.payment_method.length; i++) {
            firstData.payment_method[i] =
              i + 1 == item.payment_method_id ? 1 : 0;
          }
          data.push(firstData);
        }
      });
      return data;
    },

    labelPosition() {
      return window.matchMedia("(max-width:1024px)").matches ? "top" : "left";
    },
    deviceType() {
      return window.matchMedia("(max-width:1024px)").matches;
    },

    ...mapState("products-manager", ["products"]),
    ...mapState("sales-manager", ["product_sales"])
  },
  async created() {
    if (!(await this.getProducts()))
      this.$message.error("商品情報の取得に失敗しました");
  },
  mounted() {
    this.searchExec();
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

.aggregation-target {
  background-color: #ddd;
  width: 100%;
  margin: 10px auto;
  padding: 10px;
  border-radius: 2px;
  text-align: left;
  span {
    margin: 0px 20px;
  }
  .el-select {
    width: 100px;
  }
}
</style>

