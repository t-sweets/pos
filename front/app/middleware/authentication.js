import Cookie from "js-cookie";
export default async function ({ route, store, redirect }) {
  // Cookie情報から認証情報を取得
  let auth = Cookie.get("auth");
  if (auth) {
    auth = JSON.parse(auth);
    await store.commit("setAuth", {
        access_token: auth['access-token'],
        client: auth.client,
        uid: auth.uid
    });
  }
  

  /*
   ** Authentication 
   */
  if (!store.state.auth['access-token'] && !~route.path.indexOf('/login') && !~route.path.indexOf('/register') && !~route.path.indexOf('/logout')) {
    return redirect('/admin/login/')
  } else if (store.state.auth['access-token'] && (~route.path.indexOf('/login') || ~route.path.indexOf('/register') || ~route.path.indexOf('/logout'))) {
    await store.commit("getAuthorities")
    await store.commit("getUserData")
    return redirect('/admin/')
  }
}