<template>
  <div class="container">
    <el-menu default-active="2" class="el-menu-vertical-demo" :collapse="isCollapse">
      <el-submenu index="1">
        <template slot="title">
          <i class="el-icon-goods"></i>
          <span slot="title">商品情報</span>
        </template>
        <el-menu-item-group>
          <el-menu-item
            index="1-1"
            v-if="['admin','inventoryer', 'arriver'].includes(getUserAuthorityName)"
            @click="$router.push('/admin/products/')"
          >商品照会</el-menu-item>
          <el-menu-item
            index="1-2"
            v-if="['admin','inventoryer', 'arriver'].includes(getUserAuthorityName)"
            @click="$router.push('/admin/products/create')"
          >商品登録</el-menu-item>
          <el-menu-item
            index="1-3"
            v-if="['admin','inventoryer'].includes(getUserAuthorityName)"
            @click="$router.push('/admin/products/edit')"
          >商品編集</el-menu-item>
          <el-menu-item
            index="1-4"
            v-if="['admin','inventoryer'].includes(getUserAuthorityName)"
            @click="$router.push('/admin/products/delete')"
          >商品削除</el-menu-item>
        </el-menu-item-group>
      </el-submenu>
      <el-menu-item
        v-if="['admin','inventoryer', 'arriver'].includes(getUserAuthorityName)"
        index="3"
        @click="$router.push('/admin/arrive/')"
      >
        <i class="el-icon-sold-out"></i>
        <span slot="title">入荷作業</span>
      </el-menu-item>
      <el-submenu index="3">
        <template slot="title">
          <i class="el-icon-printer"></i>
          <span slot="title">購買情報</span>
        </template>
        <el-menu-item-group>
          <el-menu-item
            index="3-1"
            v-if="['admin','inventoryer', 'arriver'].includes(getUserAuthorityName)"
            @click="$router.push('/admin/purchases/')"
          >ジャーナル照会</el-menu-item>
          <el-menu-item
            index="3-2"
            v-if="['admin','inventoryer'].includes(getUserAuthorityName)"
            @click="$router.push('/admin/purchases/return')"
          >全返品</el-menu-item>
        </el-menu-item-group>
      </el-submenu>
      <el-submenu index="4">
        <template slot="title">
          <i class="el-icon-service"></i>
          <span slot="title">売上情報</span>
        </template>
        <el-menu-item-group>
          <el-menu-item
            index="4-1"
            v-if="['admin', 'inventoryer', 'arriver'].includes(getUserAuthorityName)"
            @click="$router.push('/admin/sales/daily')"
          >日計売上</el-menu-item>
          <el-menu-item
            index="4-2"
            v-if="['admin', 'inventoryer', 'arriver'].includes(getUserAuthorityName)"
            @click="$router.push('/admin/sales/productly')"
          >商品別売上</el-menu-item>
        </el-menu-item-group>
      </el-submenu>
      <el-submenu index="6">
        <template slot="title">
          <i class="el-icon-service"></i>
          <span slot="title">ユーザー管理</span>
        </template>
        <el-menu-item-group>
          <el-menu-item
            index="6-1"
            v-if="['admin', 'inventoryer'].includes(getUserAuthorityName)"
            @click="$router.push('/admin/users/')"
          >ユーザーリスト</el-menu-item>
          <el-menu-item
            index="6-2"
            v-if="['admin','inventoryer'].includes(getUserAuthorityName)"
            @click="$router.push('/admin/users/create')"
          >新規ユーザー作成</el-menu-item>
          <el-menu-item
            index="6-3"
            v-if="['admin'].includes(getUserAuthorityName)"
            @click="$router.push('/admin/users/edit')"
          >ユーザー情報変更</el-menu-item>
        </el-menu-item-group>
      </el-submenu>
    </el-menu>
  </div>
</template>


<script>
import { mapState, mapGetters, mapActions } from "vuex";
export default {
  data() {
    return {
      isCollapse: false
    };
  },
  methods: {
    ...mapActions(["getAuthorities", "getUserData"])
  },
  computed: {
    deviceScale() {
      return window.innerWidth;
    },
    ...mapState(["user"]),
    ...mapGetters(["getUserAuthorityName"]),
    ...mapState(["auth"])
  },
  created() {
    this.isCollapse = !(this.deviceScale > 1024);
  },
  async mounted() {
    if (this.auth["access-token"] && this.auth.uid && this.auth.client) {
      if ((await this.getAuthorities()) && (await this.getUserData())) {
      } else {
        // エラー時のメッセージ
      }
    }
  }
};
</script>

<style lang="scss" scoped>
.el-menu-vertical-demo:not(.el-menu--collapse) {
  width: 200px;
  min-height: 400px;
}
</style>