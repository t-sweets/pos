export const state = () => ({
  token: null,
  uuid: null,
  
  account: {
      name: process.env.TPAY_ACCOUNT_NAME,
      password: process.env.TPAY_ACCOUNT_PASSWORD,
      merchant_id: process.env.MERCHANT_ID,
  }
})

export const mutations = {
  setToken(state, token) {
      state.token = {
          Authorization: "Token " + token
      };
  },
  setAccount(state, data) {
      state.account = {
          ...data
      } 
  }
}

export const actions = {

  async getApiToken({state, commit}) {
      const response = await this.$axios({
          method: "POST",
          headers: {
              "Content-Type": "application/json;charset=UTF-8",
              "Access-Control-Allow-Origin": "*",  
          },
          url: process.env.TPAY_HOST + "/accounts/login/",
          data: {
              username: state.account.name,
              password: state.account.password
          },
          timeout : 5000,
      }).catch(err => {
          return false
      })

      if (response.status == 200) {
          await commit("setToken", response.data.token)
          return true
      } else return false 
  },

  async refund({state}, uuid) {
    const response = await this.$axios({
      method: "DELETE",
      headers: {
          "Content-Type": "application/json;charset=UTF-8",
          "Access-Control-Allow-Origin": "*",
          ...state.token
      },
      url: `${process.env.TPAY_HOST}/checkouts/${uuid}/`,
      data: {
          merchant_id: state.account.merchant_id,
      },
      timeout : 5000
    }).catch(err => {
        return err.response
    })

    if (response && response.status == 204) {
        return true
    } else if (response && response.status) {
      return response.status
    } else return false 
  }
}

export const getters = {
  isServiceable(state) {
      return state.account.name && state.account.password && state.account.merchant_id
  } 
};