export const state = () => ({
  sales_data: [],
  product_sales: []
});

export const mutations = {
  setSales(state, data) {
    state.sales_data = data
  },
  setProductSales(state, data) {
    state.product_sales = data
  }
}

export const actions = {
  /**
   * 商品情報の一覧を取得
   */
  async getDailySales({ commit, rootState }, { date, target }) {
    let param;
    switch(target) {
      case "time":
        param = `year=${date.getFullYear()}&month=${date.getMonth()+1}&date=${date.getDate()}`
        break
      case "date":
        param = `year=${date.getFullYear()}&month=${date.getMonth()+1}`
        break
      case "month":
        param = `year=${date.getFullYear()}`
        break
      case "year":
        param = "";
        break
    }
    const response = await this.$axios({
      method: "GET",
      headers: {
        "Content-Type": "application/json;charset=UTF-8",
        "Access-Control-Allow-Origin": "*",
        ...rootState.auth
      },
      url: `${process.env.POS_HOST}/purchases/sales?` + param,
      timeout: 3000
    }).catch(err => {
        return err.response
    });

    if (response.status == 200) {
      commit("setSales", response.data)
      return true
    } else {
      return false
    }
  },

  async getProductSales({ commit, rootState }, { product_id, from, to }) {
    let param = `from=${new Date(from).getTime()}&to=${new Date(to).getTime()}`
    param += product_id ? `&product_id=${product_id}` : ''
    const response = await this.$axios({
      method: "GET",
      headers: {
        "Content-Type": "application/json;charset=UTF-8",
        "Access-Control-Allow-Origin": "*",
        ...rootState.auth
      },
      url: `${process.env.POS_HOST}/purchases/sales?${param}`,
      timeout: 3000
    }).catch(err => {
        return err.response
    });

    if (response.status == 200) {
      commit("setProductSales", response.data)
      return true
    } else {
      return false
    }
  }
}

export const getters = {
}