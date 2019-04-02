<template>
  <section class="container">管理者画面</section>
</template>

<script>
export default {
  middleware: ["authentication"]
};
</script>

<style lang="scss" scoped>
.container {
  margin: 0 auto;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
}
</style>
