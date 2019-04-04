<template>
  <section class="content">
    <h2>商品編集</h2>
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
        <el-button style="float:right;" type="primary" native-type="submit">検索</el-button>
      </el-form-item>
    </el-form>

    <el-form
      ref="form"
      v-if="productForm.name != null"
      label-width="200px"
      label-position="left"
      v-model="productForm"
      size="mini"
    >
      <el-form-item label="商品名">
        <el-input v-model="productForm.name"></el-input>
      </el-form-item>
      <el-form-item label="JANコード">
        <el-input v-model="productForm.name"></el-input>
      </el-form-item>
      <el-form-item label="商品画像">
        <el-col :span="11">
          <img :src="toImageUrl" class="product-confirm-image">
        </el-col>
      </el-form-item>
      <el-form-item label="在庫数">
        <el-input v-model="productForm.stock"></el-input>
      </el-form-item>
      <el-form-item label="販売価格">
        <el-input v-model="productForm.price"></el-input>
      </el-form-item>
      <el-form-item label="原価（入荷時価格）">
        <el-input v-model="productForm.cost"></el-input>
      </el-form-item>
      <el-form-item label="在庫通知">
        <p
          class="form-text"
        >{{productForm.notification ? "残り在庫数が" + productForm.notification_stock + "個以下で通知" : "通知しない"}}</p>
      </el-form-item>
      <el-form-item label="表示">
        <p class="form-text">{{productForm.display ? "表示する" : "表示しない"}}</p>
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
        name: "",
        jancode: ""
      },
      productForm: {
        name: null,
        jan: null,
        image: null,
        stock: 0,
        price: 0,
        cost: 0,
        notification: false,
        display: false
      },
      product: null,
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
        this.productForm = product;
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
    /**
     * 画像URLに変換
     */
    toImageUrl() {
      return this.productForm.image_path
        ? this.productForm.image_path.match(
            /^(https?|ftp)(:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+)$/
          )
          ? this.productForm.image_path
          : process.env.POS_HOST + "/../.." + this.productForm.image_path
        : "";
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
