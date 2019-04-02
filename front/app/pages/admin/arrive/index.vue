<template>
  <section class="content">
    <h2>一括入荷</h2>
    <el-form
      ref="form"
      :model="searchForm"
      label-width="80px"
      :label-position="labelPosition"
      @submit.native.prevent="searchSumbit"
      size="small"
      :inline="!deviceType"
    >
      <el-form-item label="商品名">
        <!-- <el-input class="inline-input" clearable v-model="searchForm.name"></el-input> -->
        <el-autocomplete
          class="inline-input"
          v-model="searchForm.name"
          :fetch-suggestions="querySearch"
          placeholder="Please Input"
        ></el-autocomplete>
      </el-form-item>
      <el-form-item label="JAN">
        <el-input class="inline-input" clearable v-model="searchForm.jancode"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button style="float:right;" type="primary" native-type="submit">追加</el-button>
      </el-form-item>
    </el-form>

    <el-table
      :data="queueData"
      style="width: 100%"
      ref="queueList"
      row-class-name="over-char-hidden"
      height="500"
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55"></el-table-column>
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
                <img :src="toImageUrl(props.$index)" class="product-confirm-image">
              </el-col>
            </el-form-item>
            <el-form-item label="在庫数">
              <p class="form-text" style="font-weight:bold;color:red;">{{ props.row.stock }}&nbsp;個</p>
            </el-form-item>
            <el-form-item label="販売価格">
              <p class="form-text">{{ props.row.price }}&nbsp;円</p>
            </el-form-item>
            <el-form-item label="原価（入荷時価格）">
              <p class="form-text">{{ props.row.cost }}&nbsp;円</p>
            </el-form-item>
            <el-form-item label="在庫通知">
              <p
                class="form-text"
              >{{props.row.notification ? "残り在庫数が" + props.row.notification_stock + "個以下で通知" : "通知しない"}}</p>
            </el-form-item>
            <el-form-item label="表示">
              <p class="form-text">{{props.row.display ? "表示する" : "表示しない"}}</p>
            </el-form-item>
          </el-form>
        </template>
      </el-table-column>
      <el-table-column prop="name" label="商品名" width="400"></el-table-column>
      <el-table-column prop="quantity" label="入荷数"></el-table-column>
      <el-table-column label="数量">
        <template slot-scope="props">
          <el-input-number v-model="props.row.quantity" :min="1" size="small"></el-input-number>
        </template>
      </el-table-column>
    </el-table>
    <div style="margin-top: 20px">
      <el-button v-if="isSelected" @click="removeSelectionQueue()">選択した商品を削除</el-button>
      <el-button
        v-if="queueData.length > 0"
        @click="isConfirmDialog = true"
        type="primary"
        style="float:right;"
      >入荷確定</el-button>
    </div>

    <el-dialog title="入荷数の確認" :visible.sync="isConfirmDialog">
      <el-table :data="initializedQueue" height="400">
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
                  <img :src="toImageUrl(props.$index)" class="product-confirm-image">
                </el-col>
              </el-form-item>
              <el-form-item label="在庫数">
                <p
                  class="form-text"
                  style="font-weight:bold;color:red;"
                >{{ props.row.stock }}&nbsp;個</p>
              </el-form-item>
              <el-form-item label="販売価格">
                <p class="form-text">{{ props.row.price }}&nbsp;円</p>
              </el-form-item>
              <el-form-item label="原価（入荷時価格）">
                <p class="form-text">{{ props.row.cost }}&nbsp;円</p>
              </el-form-item>
              <el-form-item label="在庫通知">
                <p
                  class="form-text"
                >{{props.row.notification ? "残り在庫数が" + props.row.notification_stock + "個以下で通知" : "通知しない"}}</p>
              </el-form-item>
              <el-form-item label="表示">
                <p class="form-text">{{props.row.display ? "表示する" : "表示しない"}}</p>
              </el-form-item>
            </el-form>
          </template>
        </el-table-column>
        <el-table-column prop="name" label="商品名"></el-table-column>
        <el-table-column prop="quantity" label="合計入荷数" width="100"></el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
        <el-button @click="isConfirmDialog = false">キャンセル</el-button>
        <el-button type="primary" @click="arrivalConfirm()">登録する</el-button>
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
      searchForm: {
        name: "",
        jancode: ""
      },
      queueData: [],
      isSelected: false,
      isConfirmDialog: false
    };
  },
  methods: {
    /**
     * 商品名検索の一覧
     */
    querySearch(queryString, cb) {
      const lists = this.products.map(product => {
        return { value: product.name };
      });
      var results = queryString
        ? lists.filter(item => {
            return item.value.indexOf(queryString) > -1;
          })
        : lists;
      cb(results);
    },
    /**
     * 商品を検索して追加（基本JAN）
     */
    async searchSumbit() {
      let product;
      if (this.searchForm.jancode != "") {
        product = await this.getProductWithReader(this.searchForm.jancode);
      } else if (this.searchForm.name) {
        this.products.some(_product => {
          if (this.searchForm.name == _product.name) {
            product = _product;
            return true;
          } else false;
        });
      } else return false;
      if (product) {
        this.queueData.push({
          quantity: 1,
          ...product
        });
      } else {
        this.$alert("未登録商品です", "Error", {
          confirmButtonText: "OK",
          type: "error"
        });
      }
      this.searchForm = {
        name: "",
        jancode: ""
      };
    },
    /**
     * 画像URLに変換
     */
    toImageUrl(index) {
      return this.queueData[index].image_path
        ? this.queueData[index].image_path.match(
            /^(https?|ftp)(:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+)$/
          )
          ? this.queueData[index].image_path
          : process.env.POS_HOST + "/../.." + this.queueData[index].image_path
        : "";
    },
    /**
     * tableのselectboxをクリックした時の挙動
     */
    handleSelectionChange(selections) {
      this.queueData.forEach(queue => {
        queue.selected = false;
      });
      if (selections.length > 0) {
        selections.forEach(queue => {
          queue.selected = true;
        });
        this.isSelected = true;
      } else this.isSelected = false;
    },
    removeSelectionQueue() {
      this.queueData = this.queueData.filter(queue => {
        return !queue.selected;
      });
    },
    arrivalConfirm() {
      this.$confirm("入荷情報を登録しますか？", "Warning", {
        confirmButtonText: "登録",
        cancelButtonText: "キャンセル",
        type: "warning"
      }).then(async () => {
        const loading = this.$loading({ lock: true });
        const result = this.initializedQueue.every(async (queue, index) => {
          const response = await this.arrivalProduct({
            id: queue.id,
            quantity: queue.quantity
          });
          if (response) this.initializedQueue.splice(index, 1);
          return response;
        });

        await loading.close();
        if (result) {
          this.isConfirmDialog = false;
          this.queueData = [];
          this.$notify({
            title: "登録成功",
            message: "入荷情報を登録しました",
            type: "success"
          });
        } else {
          this.$alert("商品の更新に失敗しました", "Error", {
            confirmButtonText: "OK",
            type: "error"
          });
        }
      });
    },
    ...mapActions("products-manager", [
      "getProducts",
      "getProductWithReader",
      "arrivalProduct"
    ])
  },
  computed: {
    labelPosition() {
      return window.matchMedia("(max-width:1024px)").matches ? "top" : "left";
    },
    deviceType() {
      return window.matchMedia("(max-width:1024px)").matches;
    },
    initializedQueue() {
      let result = [];
      this.queueData.forEach(queue => {
        if (
          !result.some(item => {
            if (queue.id == item.id) return (item.quantity += queue.quantity);
            else return false;
          })
        )
          result.push(Object.assign({}, queue));
      });
      return result;
    },
    ...mapState("products-manager", ["products"])
  },
  async mounted() {
    if ((await this.getProducts()) === false) {
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
  .product-confirm-image {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    overflow: hidden;
    width: 70px;
    height: 70px;
    display: block;
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
