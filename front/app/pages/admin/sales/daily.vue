<template>
  <section class="content">
    <h2>日計売上</h2>
    <div class="aggregation-target">
      <span>集計対象</span>
      <el-select v-model="searchForm.target" placeholder="Select" size="small" @change="searchExec">
        <el-option
          v-for="item in target_list"
          :key="item.value"
          :label="item.label"
          :value="item.value"
        ></el-option>
      </el-select>
      <el-date-picker
        v-if="this.searchForm.target == 'time'"
        v-model="searchForm.date"
        type="date"
        placeholder="Select"
        size="small"
        :clearable="false"
        @change="searchExec"
      ></el-date-picker>
      <el-date-picker
        v-else-if="this.searchForm.target == 'date'"
        v-model="searchForm.date"
        type="month"
        placeholder="Select"
        size="small"
        :clearable="false"
        @change="searchExec"
      ></el-date-picker>
      <el-date-picker
        v-else-if="this.searchForm.target == 'month'"
        v-model="searchForm.date"
        type="year"
        placeholder="Select"
        size="small"
        :clearable="false"
        @change="searchExec"
      ></el-date-picker>
      <!-- <el-button plain style="margin-left: 100px;" size="small" @click="searchExec">表示する</el-button> -->
    </div>
    <bar-chart ref="barChart" :data="graphData" :options="graphOptions"/>
    <el-table
      class="manage-list"
      :data="dateForTable"
      :default-sort="{prop: 'period', order: 'ascending'}"
      style="width: 100%"
    >
      <el-table-column prop="period" label="集計期間" sortable>
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

    <el-dialog :visible.sync="isDetailDialog" title="売上の詳細" width="80%">
      <p>{{ detailDateLabel }}</p>
      <el-table :data="detailSalesData" size="mini" height="500">
        <el-table-column type="expand">
          <template slot-scope="props">
            <el-form label-width="100px" :label-position="labelPosition" size="mini">
              <el-form-item label="決済日時">
                <p class="form-text">{{ dateFormat(new Date(props.row.created_at)) }}</p>
              </el-form-item>
              <el-form-item label="購入商品">
                <el-table
                  :data="props.row.purchase_items"
                  style="width: 100%"
                  ref="queueList"
                  row-class-name="over-char-hidden"
                  size="mini"
                >
                  <el-table-column label="商品名" width="400">
                    <template slot-scope="scope">
                      <p class="form-text">{{ findProduct(scope.row.product_id) }}</p>
                    </template>
                  </el-table-column>
                  <el-table-column label="金額" sortable prop="price"></el-table-column>
                  <el-table-column label="個数" sortable prop="quantity"></el-table-column>
                </el-table>
              </el-form-item>
              <el-form-item label="支払金額">
                <p class="form-text">{{ props.row.totalPrice }}</p>
              </el-form-item>
              <el-form-item label="決済方法">
                <p class="form-text">{{ paymentMethod(props.row.payment_method_id) }}</p>
              </el-form-item>
            </el-form>
          </template>
        </el-table-column>
        <el-table-column label="日付" prop="created_at">
          <template slot-scope="props">{{ $nuxt.dateFormat(new Date(props.row.created_at)) }}</template>
        </el-table-column>
        <el-table-column label="売上" prop="sales"></el-table-column>
      </el-table>
    </el-dialog>
  </section>
</template>

<script>
import { mapGetters, mapActions, mapState } from "vuex";
import BarChart from "@/components/sales/DailySalesChart";

export default {
  data() {
    return {
      searchForm: {
        target: "date",
        date: new Date()
      },
      target_list: [
        {
          value: "time",
          label: "時間別"
        },
        {
          value: "date",
          label: "日別"
        },
        {
          value: "month",
          label: "月別"
        },
        {
          value: "year",
          label: "年別"
        }
      ],

      isDetailDialog: false,
      detailDateLabel: "",
      detailSalesData: [], //詳細表示の際のデータの保管所

      isShowGraph: false,
      graphData: {
        labels: [],
        datasets: [
          {
            label: "売上",
            backgroundColor: "rgba(54, 180, 235, 0.3)",
            borderColor: "rgba(54, 162, 235, 1)",
            borderWidth: 0.5,
            data: []
          }
        ]
      },
      graphOptions: {
        maintainAspectRatio: false,
        scales: {
          xAxes: [
            {
              gridLines: {
                display: false
              }
            }
          ],
          yAxes: [
            {
              gridLines: {
                display: true
              },
              ticks: {
                min: 0
              }
            }
          ]
        }
      }
    };
  },
  methods: {
    async searchExec() {
      let labels = [];
      if (await this.getDailySales(this.searchForm)) {
        switch (this.searchForm.target) {
          case "time":
            [...new Array(24)].map((v, i) => {
              labels.push(i);
            });
            break;
          case "date":
            [
              ...new Array(
                new Date(
                  this.searchForm.date.getFullYear(),
                  this.searchForm.date.getMonth() + 1,
                  0
                ).getDate()
              )
            ].map((v, i) => {
              labels.push(i + 1);
            });

            break;
          case "month":
            labels = [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "May",
              "Jun",
              "Jul",
              "Aug",
              "Sep",
              "Oct",
              "Nov",
              "Dec"
            ];
            break;
          case "year":
            let min = 2300,
              max = 1990;
            this.sales_data.forEach(data => {
              const year = new Date(data.created_at).getFullYear();
              if (year > max) max = year;
              if (min > year) min = year;
            });
            [...new Array(max - min + 1)].map((v, i) => labels.push(min + i));
            break;
        }
        this.graphData.datasets[0].data = this.dateForGraph;
        this.graphData.labels = labels;
        this.$refs.barChart.reload();
      }
    },
    toStrDate(date) {
      switch (this.searchForm.target) {
        case "time":
          return this.$nuxt.dateFormat(new Date(date), "MM/DD(E) hh時");
          break;
        case "date":
          return this.$nuxt.dateFormat(new Date(date), "MM/DD(E)");
          break;
        case "month":
          return this.$nuxt.dateFormat(new Date(date), "YYYY年MM月");
          break;
        case "year":
          return this.$nuxt.dateFormat(new Date(date), "YYYY年");
          break;
      }
      return "";
    },

    /**
     * サマリーメソッド
     */
    getSummaries(param) {
      console.log(param);

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
    },

    showDetialDialog(period) {
      this.detailDateLabel = $nuxt.dateFormat(
        new Date(period),
        "YYYY年MM月DD日"
      );
      this.detailSalesData = this.getDetailDatas(period);
      this.isDetailDialog = true;
    },

    /**
     * 詳細表示用のデータを取得
     */
    getDetailDatas(period) {
      let datas = [];
      const period_date = new Date(period);
      this.sales_data.forEach(item => {
        const created_date = new Date(item.created_at);
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
          // 合計金額を算出
          let total = 0;
          item.purchase_items.forEach(item => {
            total += item.price * item.quantity;
          });

          datas.push({
            totalPrice: total,
            ...item
          });
        }
      });
      return datas;
    },

    /**
     * 決済名を取得
     */
    paymentMethod(id) {
      return this.payment_method[id - 1].name;
    },

    findProduct(id) {
      return this.products.find(product => product.id == id).name;
    },

    ...mapActions("sales-manager", ["getDailySales"]),
    ...mapActions("purchases-manager", ["getPaymentMethod"]),
    ...mapActions("products-manager", ["getProducts"])
  },
  computed: {
    /*
     ** 売上がない場合でも
     */
    dateForGraph() {
      let data;
      let min_year = 2300,
        max_year = 1990;
      switch (this.searchForm.target) {
        //データを入れる配列を宣言
        case "time":
          data = new Array(24);
          break;
        case "date":
          const created_time = new Date(this.searchForm.date);
          data = new Array(
            new Date(
              created_time.getFullYear(),
              created_time.getMonth() + 1,
              0
            ).getDate()
          );
          break;
        case "month":
          data = new Array(12);
          break;
        case "year":
          this.sales_data.forEach(data => {
            const year = new Date(data.created_at).getFullYear();
            if (year > max_year) max_year = year;
            if (min_year > year) min_year = year;
          });
          data = new Array(max_year - min_year + 1);
          break;
      }
      // 初期値を0に
      data.fill(0);
      // for (let i = 0; i < data.length; i++) {
      //   data[i] = 0;
      // }

      // 取得したデータを格納
      this.sales_data.forEach(item => {
        switch (this.searchForm.target) {
          case "time":
            data[new Date(item.created_at).getHours()] += item.sales;
            break;
          case "date":
            data[new Date(item.created_at).getDate() - 1] += item.sales;
            break;
          case "month":
            data[new Date(item.created_at).getMonth()] += item.sales;
            break;
          case "year":
            data[new Date(item.created_at).getFullYear() - min_year] +=
              item.sales;
            break;
        }
      });
      return data;
    },
    dateForTable() {
      let data = [];

      this.sales_data.forEach(item => {
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

    ...mapState("purchases-manager", ["payment_method"]),
    ...mapState("products-manager", ["products"]),
    ...mapState("sales-manager", ["sales_data"])
  },
  components: {
    BarChart
  },
  async created() {
    if (!(await this.getPaymentMethod()))
      this.$message.error("決済方法一覧の取得に失敗しました");
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

