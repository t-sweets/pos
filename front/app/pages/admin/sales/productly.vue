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
      <el-table-column type="expand" :show-overflow-tooltip="true">
        <template slot-scope="props">
          <el-form ref="form" label-width="200px" label-position="left" size="mini">
            <el-form-item label="商品名">
              <p class="form-text">{{ props.row.name }}</p>
            </el-form-item>
            <el-form-item label="JANコード">
              <p class="form-text">{{ props.row.jan }}</p>
            </el-form-item>
            <el-form-item label="商品画像">
              <el-col :span="11">
                <img :src="toImageUrl(props.row.image_path)" class="product-confirm-image">
              </el-col>
            </el-form-item>
            <el-form-item label="販売価格">
              <p class="form-text">{{ props.row.price }}&nbsp;円</p>
            </el-form-item>
            <el-form-item label="入荷価格">
              <p class="form-text">{{ props.row.cost }}&nbsp;円</p>
            </el-form-item>
          </el-form>
        </template>
      </el-table-column>
      <el-table-column prop="name" label="商品名" sortable></el-table-column>
      <el-table-column label="販売総売上">
        <template slot-scope="scope">
          <p>¥{{Math.round(scope.row.price * scope.row.quantity)}}</p>
        </template>
      </el-table-column>
      <el-table-column label="構成比">
        <template slot-scope="scope">
          <p>{{ Math.round(scope.row.priceComposition * 10) / 10 }}%</p>
        </template>
      </el-table-column>
      <el-table-column label="粗利総額">
        <template slot-scope="scope">
          <p>¥{{Math.round(scope.row.price * scope.row.quantity - scope.row.cost * scope.row.quantity)}}</p>
        </template>
      </el-table-column>
      <el-table-column label="構成比">
        <template slot-scope="scope">
          <p>{{ Math.round(scope.row.grossComposition * 10) / 10 }}%</p>
        </template>
      </el-table-column>
      <el-table-column prop="quantity" label="販売商品数"></el-table-column>
      <el-table-column label="構成比">
        <template slot-scope="scope">
          <p>{{ Math.round(scope.row.quantityComposition * 10) / 10 }}%</p>
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
          from: this.searchForm.date[0] / 1000,
          to: this.searchForm.date[1] / 1000
        })
      ) {
      }
    },
    /**
     * 画像URLに変換
     */
    toImageUrl(image_path) {
      return image_path
        ? image_path.match(
            /^(https?|ftp)(:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+)$/
          )
          ? image_path
          : process.env.POS_HOST + "/../.." + image_path
        : "";
    },
    ...mapActions("purchases-manager", ["getPaymentMethod"]),
    ...mapActions("sales-manager", ["getProductSales"]),
    ...mapActions("products-manager", ["getProducts"])
  },
  computed: {
    /**
     * 表に表示するためにデータを整形
     */
    dateForTable() {
      let datas = [];

      this.product_sales.forEach(sales => {
        sales.purchase_items.forEach(item => {
          let data = datas.find(data => data.id === item.product_id);
          // dataに既に追加されていれば、販売商品数(quantity)を追加
          if (data && data.price === item.price && data.cost === item.cost) {
            data.quantity++;
          } else {
            datas.push({
              ...this.products.find(product => product.id === item.product_id),
              price: item.price,
              cost: item.cost,
              quantity: item.quantity
            });
          }
        });
      });

      const totalPrice =
        datas.length > 0
          ? datas.reduce(
              (prev, current) =>
                (typeof prev === "number" ? prev : prev.price * prev.quantity) +
                current.price * current.quantity
            )
          : 0;

      const totalGross =
        datas.length > 0
          ? datas.reduce(
              (prev, current) =>
                (typeof prev === "number"
                  ? prev
                  : prev.price * prev.quantity - prev.cost * prev.quantity) +
                current.price * current.quantity
            )
          : 0;
      const totalQuantity =
        datas.length > 0
          ? datas.reduce(
              (prev, current) =>
                (typeof prev === "number" ? prev : prev.quantity) +
                current.quantity
            )
          : 0;

      // 構成費を算出
      datas.forEach(data => {
        data.priceComposition =
          ((data.price * data.quantity) / totalPrice) * 100;
        data.grossComposition =
          ((data.price * data.quantity - data.cost * data.quantity) /
            totalGross) *
          100;
        data.quantityComposition = (data.quantity / totalQuantity) * 100;
      });
      return datas;
    },

    labelPosition() {
      return window.matchMedia("(max-width:1024px)").matches ? "top" : "left";
    },
    deviceType() {
      return window.matchMedia("(max-width:1024px)").matches;
    },

    ...mapState("purchases-manager", ["payment_method"]),
    ...mapState("products-manager", ["products"]),
    ...mapState("sales-manager", ["product_sales"])
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
  .product-confirm-image {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    overflow: hidden;
    width: 70px;
    height: 70px;
    display: block;
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


<style lang="scss">
.aggregation-target {
  .el-range-separator {
    margin: 5px;
  }
}
</style>
