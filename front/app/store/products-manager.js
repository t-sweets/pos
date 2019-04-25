let jsonpAdapter = require('axios-jsonp');

export const state = () => ({
    products: []
});

export const mutations = {
    setProducts(state, products) {
        state.products = products;
    },
    addProduct(state, product) {
        state.products.push(product);
    },
    updateProduct(state, data) {
        state.products.some((product, index) => {
            if (product.id == data.id) {
                for(let val in data) {
                    state.products[index][val] = data[val]
                }
            } else return false
        })
    },
    deleteProduct(state, id) {
        state.products.some((product, index) => {
            return (product.id == id) ? state.products.splice(index, 1) : false
        })
    }
}

export const actions = {
    /**
     * 商品情報の一覧を取得
     */
    async getProducts({commit, rootState}) {
        const response = await this.$axios({
            method: "GET",
            headers: {
                "Content-Type": "application/json;charset=UTF-8",
                "Access-Control-Allow-Origin": "*",
                ...rootState.auth
            },
            url: process.env.POS_HOST+"/products",
            timeout: 3000
        })
        .catch(err => {
            return false
        });

        if (response.status == 200) {
            commit("setProducts", response.data)
            return true
        } else {
            return false
        }
    },

    async createProduct({commit, dispatch, rootState}, data) {
        const response = await this.$axios({
            method: "POST",
            headers: {
                "Content-Type": "application/json;charset=UTF-8",
                "Access-Control-Allow-Origin": "*",
                ...rootState.auth
            },
            url: process.env.POS_HOST+"/products",
            data: {
                ...data
            },
            timeout: 5000
        }).catch(err => {return false})

        if (response.status == 201 && response.data.success) {
            await dispatch("getProducts")
            return true
        } else return false;
    },

    async updateProduct({commit, rootState}, {id, data}) {
        const response = await this.$axios({
            method: "PUT",
            headers: {
                "Content-Type": "application/json;charset=UTF-8",
                "Access-Control-Allow-Origin": "*",
                ...rootState.auth
            },
            url: process.env.POS_HOST+"/products/"+id,
            data: {
                ...data
            },
            timeout: 3000
        }).catch(err => {
            return false
        })

        if (response.status == 200 && response.data.success) {
            await commit("updateProduct", response.data.product)
            return true
        } else return false
    },

    async arrivalProduct({commit, rootState}, {id, quantity}) {
        const response = await this.$axios({
            method: "POST",
            headers: {
                "Content-Type": "application/json;charset=UTF-8",
                "Access-Control-Allow-Origin": "*",
                ...rootState.auth
            },
            url: `${process.env.POS_HOST}/products/${id}/stock`,
            data: {
                additional_quantity: quantity
            },
            timeout: 3000
        }).catch(err => {
            return err.response
        })

        if (response.status == 200 && response.data.success) return true
        else return false
    },

    async deleteProduct({commit, rootState}, id) {
        const response = await this.$axios({
            method: "DELETE",
            headers: {
                "Content-Type": "application/json;charset=UTF-8",
                "Access-Control-Allow-Origin": "*",
                ...rootState.auth
            },
            url: process.env.POS_HOST+"/products/"+id,
            timeout: 3000
        }).catch(err => {
            return err.response
        })

        if (response.status == 204) {
            return true
        } else return false;
    },

    async getProductWithReader({rootState}, jancode) {
        if (!jancode) return false;
        const response = await this.$axios({
            method: "GET",
            headers: {
                "Content-Type": "application/json;charset=UTF-8",
                "Access-Control-Allow-Origin": "*",
                ...rootState.auth
            },
            url: process.env.POS_HOST +"/products/jan/"+ jancode,
            timeout: 3000
        })
        .catch(err => {
            return err.response
        });

        if (response.status == 200) {
            return response.data
        } else {
            return false
        }
    },

    async getProductInfo({},jancode) {
        const response = await this.$axios({
            method: "GET",
            headers: {
                "Content-Type": "application/json;charset=UTF-8",
                "Access-Control-Allow-Origin": "*"
            },
            adapter: jsonpAdapter,
            url: process.env.YAHOODEV_REQUEST_URL,
            params: {
                appid: process.env.YAHOODEV_CLIENT_ID,
                jan: jancode,
                hits: 1
            },
            crossDomain: true,
            timeout: 3000
        }).catch(err => {
            return err.response
        })

        if (response.status == 200 && parseInt(response.data.ResultSet.totalResultsReturned) > 0) {
            return response.data.ResultSet[0].Result[0];
        } else return false;
    },
}
