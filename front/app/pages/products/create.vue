<template>
  <section class="content">
    <h2>商品登録</h2>
    <el-form
      ref="productCreateForm"
      :model="createForm"
      label-width="130px"
      :label-position="labelPosition"
      size="small"
      :inline="!deviceType"
    >
      <el-form-item label="商品名" :required="true">
        <el-col :span="24">
          <el-input class="inline-input" v-model="createForm.name"></el-input>
        </el-col>
      </el-form-item>
      <el-form-item label="JANコード" :required="true">
        <el-col :span="24">
          <el-input id="janForm" class="inline-input" v-model="createForm.jan"></el-input>
        </el-col>
      </el-form-item>
      <el-form-item label="販売価格/原価" :required="true">
        <el-col :span="11">
          <el-input-number
            class="inline-input-number"
            v-model="createForm.price"
            :min="1"
            :max="9999"
            :step="10"
          ></el-input-number>
        </el-col>
        <el-col class="line" :span="2">/</el-col>
        <el-col :span="11">
          <el-input-number
            class="inline-input-number"
            v-model="createForm.cost"
            :min="10"
            :max="9999"
          ></el-input-number>
        </el-col>
      </el-form-item>
      <el-form-item label="画像" :required="true">
        <el-col :span="12">
          <el-upload
            class="product-image-uploader inline-input"
            action="#"
            :show-file-list="false"
            :before-upload="convertToBase64"
          >
            <img
              v-if="createForm.image || createForm.image_path"
              :src="toImageData"
              class="product-image"
              id="productImage"
            >
            <i v-else class="el-icon-plus product-image-uploader-icon"></i>
          </el-upload>
        </el-col>
      </el-form-item>
      <br v-show="!deviceType">
      <el-form-item label="在庫数" :required="true">
        <el-col :span="12">
          <el-input-number
            class="inline-input-number"
            v-model="createForm.stock"
            :min="0"
            :max="999"
          ></el-input-number>
        </el-col>
      </el-form-item>
      <br v-show="!deviceType">
      <el-form-item label="在庫通知/通知個数">
        <el-col :span="11">
          <el-switch active-text="通知する" inactive-text="通知しない" v-model="createForm.notification"></el-switch>
        </el-col>
        <el-col class="line" :span="2" v-show="!deviceType">/</el-col>
        <el-col :span="11">
          <el-input-number
            class="inline-input-number"
            v-model="createForm.notification_stock"
            :min="0"
            :max="99"
            :disabled="!createForm.notification"
          ></el-input-number>
        </el-col>
      </el-form-item>
      <br v-show="!deviceType">
      <el-form-item label="表示">
        <el-switch v-model="createForm.display" active-text="表示する" inactive-text="表示しない"></el-switch>
      </el-form-item>
      <el-form-item style="width:90%;">
        <el-button plain size="medium" @click="formReset">リセット</el-button>
        <el-button type="primary" @click="openRegisterConfirm" size="medium">登録内容の確認</el-button>
      </el-form-item>
    </el-form>

    <el-dialog title="入荷数の確認" :visible.sync="isConfirmDialog">
      <el-form ref="form" label-width="200px" label-position="left" size="mini">
        <el-form-item label="商品名">
          <p class="form-text">{{ createForm.name }}</p>
        </el-form-item>
        <el-form-item label="JANコード">
          <p class="form-text">{{ createForm.jan }}</p>
        </el-form-item>
        <el-form-item label="商品画像">
          <el-col :span="11">
            <img :src="toImageUrl" class="product-confirm-image">
          </el-col>
        </el-form-item>
        <el-form-item label="在庫数">
          <p class="form-text" style="font-weight:bold;color:red;">{{ createForm.stock }}&nbsp;個</p>
        </el-form-item>
        <el-form-item label="販売価格">
          <p class="form-text">{{ createForm.price }}&nbsp;円</p>
        </el-form-item>
        <el-form-item label="原価（入荷時価格）">
          <p class="form-text">{{ createForm.cost }}&nbsp;円</p>
        </el-form-item>
        <el-form-item label="在庫通知">
          <p
            class="form-text"
          >{{createForm.notification ? "残り在庫数が" + createForm.notification_stock + "個以下で通知" : "通知しない"}}</p>
        </el-form-item>
        <el-form-item label="表示">
          <p class="form-text">{{createForm.display ? "表示する" : "表示しない"}}</p>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="isConfirmDialog = false">キャンセル</el-button>
        <el-button type="primary" @click="registerProduct()">登録する</el-button>
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
      createForm: {
        name: "",
        jan: "",
        price: 100,
        cost: 100,
        stock: 0,
        display: true,
        image_path: null,
        notification: true,
        notification_stock: 0,
        image: null
      },
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
     * JANコードから商品情報をAPIで取得
     */
    async searchProductInfo() {
      if (this.$nuxt.jancodeValidate(this.createForm.jan)) {
        if ((await this.getProductWithReader(this.createForm.jan)) !== false) {
          this.$alert("登録済の商品です", "Error", {
            confirmButtonText: "OK",
            type: "error"
          });
          this.createForm.jan = "";
        } else {
          const data = await this.getProductInfo(this.createForm.jan);
          if (!data) return false;
          if (this.createForm.name == "") this.createForm.name = data.Name;
          if (this.createForm.image_path == null) {
            this.createForm.image_path = data.Image.Medium;
          }
        }
      }
    },

    /**
     * base64画像にコンバート
     */
    convertToBase64(file) {
      let fr = new FileReader();
      fr.onload = evt => {
        this.createForm.image = evt.target.result.split("base64,")[1];
        this.createForm.image_path = file.name;
      };
      fr.readAsDataURL(file);
    },

    openRegisterConfirm() {
      if (this.createForm.name != "" && this.createForm.jan != "") {
        this.isConfirmDialog = true;
      } else {
        this.$message.error("必要事項を入力してください");
      }
    },

    /**
     * 商品の追加
     */
    async registerProduct() {
      const loading = this.$loading({ lock: true });
      if (await this.createProduct(this.createForm)) {
        this.$notify({
          title: "登録成功",
          message: "入荷情報を登録しました",
          type: "success"
        });
        this.formReset();
        this.isConfirmDialog = false;
      } else {
        this.$alert("商品の更新に失敗しました", "Error", {
          confirmButtonText: "OK",
          type: "error"
        });
      }
      loading.close();
    },

    /**
     * フォームリセット
     */
    formReset() {
      this.createForm = {
        name: "",
        jan: "",
        price: 100,
        cost: 100,
        stock: 0,
        display: true,
        image_path: null,
        notification: true,
        notification_stock: 0,
        image: null
      };
    },

    ...mapActions("products-manager", [
      "getProducts",
      "getProductWithReader",
      "getProductInfo",
      "createProduct"
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
      return this.createForm.image_path
        ? this.createForm.image_path.match(
            /^(https?|ftp)(:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+)$/
          )
          ? this.createForm.image_path
          : process.env.POS_HOST + "/../.." + this.createForm.image_path
        : "";
    },
    toImageData() {
      return this.createForm.image
        ? "data:image/png;base64," + this.createForm.image
        : this.createForm.image_path;
    },
    ...mapState("products-manager", ["products"])
  },
  async mounted() {
    document.getElementById("janForm").addEventListener("keydown", async e => {
      if (e.keyCode === 13) {
        this.searchProductInfo();
      }
    });
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
  .inline-input-number {
    @include pc {
      width: 250px;
    }
    @include tab {
      width: 200px;
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
