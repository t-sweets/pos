import Cookie from "js-cookie";
export default async function ({ route, store, redirect }) {
  // Cookie情報から認証情報を取得
  let authdata = Cookie.get("authdata");
  
  if (authdata) {
    try {
      authdata = JSON.parse(authdata)
      await store.commit("setAuth", authdata.auth);  
      await store.commit("setUserData", authdata.user);
      
    } catch (e) {
      
    }
  }
  
  // console.log(store.getters['isAuthDataValid']);
  

  /*
   ** Authentication 
   */
  if (!store.getters.isAuthDataValid && !~route.path.indexOf('/login') && !~route.path.indexOf('/register') && !~route.path.indexOf('/logout')) {
    return redirect('/admin/login/')
  } else if (store.getters.isAuthDataValid && (~route.path.indexOf('/login') || ~route.path.indexOf('/register') || ~route.path.indexOf('/logout'))) {
    await store.commit("getAuthorities")
    await store.commit("getUserData")
    return redirect('/admin/')
  }
}