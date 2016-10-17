<template>
  <div id="main">
    <nav>
      <ul>
        <li><router-link to="/">Home</router-link></li>

        <li v-if="$store.getters.isLoggedIn">
          <router-link to="/logout">Log out</router-link>
        </li>
        <li v-else>
          <router-link to="/login">Log in</router-link>
        </li>
      </ul>
    </nav>
    <keep-alive>
      <router-view></router-view>
    </keep-alive>
  </div>
</template>

<style>
html {
  height: 100%;
}

body {
  display: flex;
  /*align-items: center;
  justify-content: center;*/
  height: 100%;
}

#app {
  margin-top: -100px;
  max-width: 600px;
  font-family: Source Sans Pro, Helvetica, sans-serif;
  text-align: center;
}

#app a {
  color: #42b983;
  text-decoration: none;
}
</style>
