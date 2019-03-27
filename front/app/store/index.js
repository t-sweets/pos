export const state = () => ({
    auth: {
        "access-token": null,
        client: null,
        uid: null
    },
    user: {
        id: -1,
        name: null,
        email: null,
        authority: null,    // 1:admin, 2:pos, 3:arriver
    },
    authority_index: []
});

export const mutations = {
    setAuth(state, {access_token, client, uid}){
        state.auth = {
            "access-token": access_token,
            client: client,
            uid: uid
        }
    },
    setAdminData(state, data) {
        state.user = {
            id: data.id,
            name: data.name,
            email: data.email,
            authority: data.authority_id
        }
    },
    setAuthorities(state, datas) {
        state.authority_index = datas
    },
}

export const actions = {
    async login({ commit }, {userkey, password}) {
        let data = {}
        if (userkey.match(/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/)) data.email = userkey
        else data.name = userkey
        const response = await this.$axios({
            method: "POST",
            headers: {
                "Content-Type": "application/json;charset=UTF-8",
                "Access-Control-Allow-Origin": "*"
            },
            data: {
                ...data,
                password: password
            },
            url: process.env.POS_HOST + "/auth/sign_in"
        })
        .catch(err => {
            return false
        });

        if (response.status == 200) {
            await commit("setAuth", {
                access_token: response.headers["access-token"],
                client: response.headers["client"],
                uid: response.headers["uid"]
            });

            await commit("setAdminData", response.data.data);

            return true
        } else {

            return false
        }
    },

    async getAuthorities({commit, state}) {
        const response = await this.$axios({
            method: "GET",
            headers: {
                "Content-Type": "application/json;charset=UTF-8",
                "Access-Control-Allow-Origin": "*",
                ...state.auth
            },
            url: process.env.POS_HOST +"/authorities",
            timeout: 3000
        })
        .catch(err => {
            return err.response
        });

        if (response.status == 200) {
            commit("setAuthorities", response.data)
            return true
        } else {
            return false
        }
    },

    /**
     * ユーザ情報だけ欲しい時。とりあえず対応
     */
    async getUserData({commit, state}) {
        const response = await this.$axios({
            method: "GET",
            headers: {
                "Content-Type": "application/json;charset=UTF-8",
                "Access-Control-Allow-Origin": "*",
                ...state.auth
            },
            url: process.env.POS_HOST +"/users",
            timeout: 3000
        })
        .catch(err => {
            return err.response
        });

        if (response.status == 200) {
            await response.data.some(async user => {
                if (user.email == state.auth.uid) {
                    await commit("setAdminData", user)
                    return true
                } else return false
            });
            return true
        } else {
            return false
        }
    },

    async logout({commit}) {
        await commit("setAuth", {
            access_token: null,
            client: null,
            uid: null
        });

        await commit("setAdminData", {
            name: null,
            authority: null
        });

    }

}

export const getters = {
    getUserAuthorityName(state) {
        let result = null;
        state.authority_index.some(authority => {
            if (state.user.authority == authority.id) {
                return result = authority.name
            } else return false;
        })
        return result
    }
}