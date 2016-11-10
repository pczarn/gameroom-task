<template>
<div id="main">
  <navigation-bar></navigation-bar>
  <alert-bar></alert-bar>
  <router-view></router-view>
</div>
</template>

<script>
import NavigationBar from 'src/components/NavigationBar'
import AlertBar from 'src/components/AlertBar'

export default {
  name: 'App',
  components: {
    NavigationBar,
    AlertBar,
  },
}
</script>

<style>
html {
  height: 100%;
  width: 100%;
}

body {
  display: flex;
  /*align-items: center;
  justify-content: center;*/
  height: 100%;
  width: 100%;
}

#main {
  height: 100%;
  width: 100%;
}

#app {
  margin-top: -100px;
  /*max-width: 600px;*/
  font-family: Source Sans Pro, Helvetica, sans-serif;
  text-align: center;
}

#app a {
  color: #42b983;
  text-decoration: none;
}
</style>
