<template>
  <div class="container">
    <el-menu
      default-active="2"
      class="el-menu-vertical-demo"
      @open="handleOpen"
      @close="handleClose"
      :collapse="isCollapse"
    >
      <el-submenu index="1">
        <template slot="title">
          <i class="el-icon-goods"></i>
          <span slot="title">商品情報</span>
        </template>
        <el-menu-item-group>
          <el-menu-item
            index="1-1"
            v-show="['admin','inventoryer', 'arriver'].includes(getUserAuthorityName)"
            @click="$router.push('/products/')"
          >商品照会</el-menu-item>
          <el-menu-item
            index="1-2"
            v-show="['admin','inventoryer', 'arriver'].includes(getUserAuthorityName)"
            @click="$router.push('/products/create')"
          >商品登録</el-menu-item>
          <el-menu-item
            index="1-3"
            v-show="['admin','inventoryer'].includes(getUserAuthorityName)"
            @click="$router.push('/products/edit')"
          >商品編集</el-menu-item>
        </el-menu-item-group>
      </el-submenu>
      <el-menu-item
        v-show="['admin','inventoryer', 'arriver'].includes(getUserAuthorityName)"
        index="3"
        @click="$router.push('/arrive/')"
      >
        <i class="el-icon-sold-out"></i>
        <span slot="title">入荷作業</span>
      </el-menu-item>
      <el-menu-item index="4">
        <i class="el-icon-menu"></i>
        <span slot="title">Navigator Two</span>
      </el-menu-item>
      <el-menu-item index="5" disabled>
        <i class="el-icon-document"></i>
        <span slot="title">Navigator Three</span>
      </el-menu-item>
      <el-menu-item index="6">
        <i class="el-icon-setting"></i>
        <span slot="title">Navigator Four</span>
      </el-menu-item>
    </el-menu>
  </div>
</template>


<script>
import { mapState, mapGetters } from "vuex";
export default {
  data() {
    return {
      isCollapse: false
    };
  },
  methods: {
    handleOpen(key, keyPath) {
      console.log(key, keyPath);
    },
    handleClose(key, keyPath) {
      console.log(key, keyPath);
    }
  },
  computed: {
    deviceScale() {
      return window.innerWidth;
    },
    ...mapState(["user"]),
    ...mapGetters(["getUserAuthorityName"])
  },
  created() {
    this.isCollapse = !(this.deviceScale > 1024);
  }
};
</script>

<style lang="scss" scoped>
.el-menu-vertical-demo:not(.el-menu--collapse) {
  width: 200px;
  min-height: 400px;
}
</style>