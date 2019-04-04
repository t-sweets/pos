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
      @submit.native.prevent="openUpdateConfirm"
    >
      <el-form-item label="商品名">
        <el-input v-model="productForm.name"></el-input>
      </el-form-item>
      <el-form-item label="JANコード">
        <el-input v-model="productForm.jan"></el-input>
      </el-form-item>
      <el-form-item label="商品画像">
        <el-col :span="11">
          <el-upload
            class="product-image-uploader"
            action="#"
            :show-file-list="false"
            :before-upload="convertToBase64"
          >
            <img
              v-if="productForm.image || productForm.image_path"
              :src="toImageUrl"
              class="product-confirm-image"
            >
            <i v-else class="el-icon-plus product-image-uploader-icon"></i>
          </el-upload>
        </el-col>
      </el-form-item>
      <el-form-item label="在庫数">
        <el-input-number v-model="productForm.stock" :min="0" :max="999"></el-input-number>
      </el-form-item>
      <el-form-item label="販売価格">
        <el-input-number v-model="productForm.price" :min="0" :max="1000" :step="10"></el-input-number>
      </el-form-item>
      <el-form-item label="原価（入荷時価格）">
        <el-input-number v-model="productForm.cost" :min="0" :max="1000"></el-input-number>
      </el-form-item>
      <el-form-item label="在庫数" :required="true">
        <el-col :span="11">
          <el-input-number v-model="productForm.stock" :min="0" :max="999"></el-input-number>
        </el-col>
      </el-form-item>
      <el-form-item label="在庫通知/通知個数">
        <el-col :span="8">
          <el-switch active-text="通知する" inactive-text="通知しない" v-model="productForm.notification"></el-switch>
        </el-col>
        <el-col class="line" :span="2">/</el-col>
        <el-col :span="11">
          <el-input-number
            v-model="productForm.notification_stock"
            :min="0"
            :max="99"
            :disabled="!productForm.notification"
          ></el-input-number>
        </el-col>
      </el-form-item>
      <el-form-item label="表示">
        <el-switch v-model="productForm.display" active-text="表示する" inactive-text="表示しない"></el-switch>
      </el-form-item>
      <el-form-item>
        <el-button style="float:right;" size="small" type="primary" native-type="submit">変更</el-button>
        <el-button style="float:right; margin-right: 10px" @click="resetForm" size="small">リセット</el-button>
      </el-form-item>
    </el-form>

    <el-dialog title="更新内容の確認" :visible.sync="isConfirmDialog">
      <el-form
        ref="form"
        :model="productForm"
        label-width="150px"
        :label-position="labelPosition"
        size="mini"
      >
        <el-form-item label="商品名">
          <el-col :span="8">
            <p class="form-text">{{ product.name }}</p>
          </el-col>
          <el-col class="line" :span="2" v-if="productForm.name !== product.name">=></el-col>
          <el-col :span="11" v-if="productForm.name !== product.name">
            <p class="form-text" style="font-weight:bold;">{{ productForm.name }}</p>
          </el-col>
        </el-form-item>
        <el-form-item label="JANコード">
          <el-col :span="11">
            <p class="form-text">{{ product.jan }}</p>
          </el-col>
          <el-col class="line" :span="2" v-if="productForm.jan !== product.jan">=></el-col>
          <el-col :span="11" v-if="productForm.jan">
            <p class="form-text" style="font-weight:bold;">{{ productForm.jan }}</p>
          </el-col>
        </el-form-item>
        <el-form-item label="画像">
          <el-col :span="8">
            <img :src="product.image_path" class="product-confirm-image">
          </el-col>
          <el-col class="line" :span="2" v-if="productForm.image">=></el-col>
          <el-col :span="11" v-if="productForm.image">
            <img :src="toImageUrl" class="product-confirm-image">
          </el-col>
        </el-form-item>
        <el-form-item label="在庫数">
          <el-col :span="5">
            <p class="form-text">{{ product.stock }}&nbsp;個</p>
          </el-col>
          <el-col class="line" :span="2" v-if="product.stock !== productForm.stock">=></el-col>
          <el-col :span="11" v-if="product.stock !== productForm.stock">
            <p class="form-text" style="font-weight:bold;">{{ productForm.stock }}&nbsp;個</p>
          </el-col>
        </el-form-item>
        <el-form-item label="販売価格">
          <el-col :span="5">
            <p class="form-text">{{ product.price }}&nbsp;円</p>
          </el-col>
          <el-col class="line" :span="2" v-if="product.price !== productForm.price">=></el-col>
          <el-col :span="11" v-if="product.price !== productForm.price">
            <p class="form-text" style="font-weight:bold;">{{ productForm.price }}&nbsp;円</p>
          </el-col>
        </el-form-item>
        <el-form-item label="原価">
          <el-col :span="5">
            <p class="form-text">{{ product.cost }}&nbsp;円</p>
          </el-col>
          <el-col class="line" :span="2" v-if="product.cost !== productForm.cost">=></el-col>
          <el-col :span="11" v-if="product.cost !== productForm.cost">
            <p class="form-text" style="font-weight:bold;">{{ productForm.cost }}&nbsp;円</p>
          </el-col>
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
      <span slot="footer" class="dialog-footer">
        <el-button @click="isConfirmDialog = false">キャンセル</el-button>
        <el-button type="primary" @click="update()">登録する</el-button>
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
      productForm: {
        name: null,
        jan: null,
        image: null,
        stock: 0,
        price: 0,
        cost: 0,
        notification: false,
        display: false,
        notification_stock: 0
      },
      product: {},
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
        // 表示用バックアップ
        this.product = product;
        // 編集用フォームの初期値
        this.productForm = {
          image: null,
          ...product
        };
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

    convertToBase64(file) {
      let fr = new FileReader();
      fr.onload = evt => {
        this.productForm.image = evt.target.result.split("base64,")[1];
      };
      fr.readAsDataURL(file);
    },

    /**
     * 確認ダイアログを開く
     */
    openUpdateConfirm() {
      if (this.productForm.name == "") {
        this.$message.error("必要事項を入力してください");
      } else if (
        this.productForm.jan != "" &&
        !$nuxt.jancodeValidate(this.productForm.jan)
      ) {
        this.$message.error("JANコードが不正です");
      } else if (
        this.productForm.image == null &&
        this.productForm.image_path == ""
      ) {
        this.$message.error("画像を指定してください");
      } else {
        this.isConfirmDialog = true;
      }
    },

    update() {
      this.$confirm("商品情報を更新しますか？", "Warning", {
        confirmButtonText: "更新",
        cancelButtonText: "キャンセル",
        type: "warning"
      }).then(async () => {
        const loading = this.$loading({ lock: true });
        if (
          await this.updateProduct({
            id: this.productForm.id,
            data: this.productForm
          })
        ) {
          this.$notify({
            title: "更新成功",
            message: "商品情報を更新しました",
            type: "success"
          });
          this.resetForm();
          this.isConfirmDialog = false;
        } else {
          this.$alert("商品の更新に失敗しました", "Error", {
            confirmButtonText: "OK",
            type: "error"
          });
        }
        loading.close();
      });
    },

    /**
     * フォーム内容をリセット
     */
    resetForm() {
      this.searchForm = {
        name: "",
        jancode: ""
      };
      this.productForm = {
        name: null,
        jan: null,
        image: null,
        stock: 0,
        price: 0,
        cost: 0,
        notification: false,
        display: false,
        notification_stock: 0
      };
    },

    ...mapActions("products-manager", [
      "getProducts",
      "getProductWithReader",
      "updateProduct",
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
      return this.productForm.image
        ? "data:image/png;base64," + this.productForm.image
        : this.productForm.image_path
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
.product-image-uploader {
  .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    &:hover {
      border-color: #409eff;
    }
  }
  .product-image-uploader-icon {
    font-size: 15px;
    color: #8c939d;
    width: 70px;
    height: 70px;
    line-height: 70px;
    text-align: center;
  }
}
</style>
