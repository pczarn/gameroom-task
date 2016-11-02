import Vue from 'vue'
import VueRouter from 'vue-router'

import store from 'src/store'
import auth from 'src/auth'

import GameList from 'components/GameList'
import Game from 'components/Game'
import GameEdit from 'components/GameEdit'
import GameRemove from 'components/GameRemove'
import TeamList from 'components/TeamList'
import MatchList from 'components/MatchList'
import Match from 'components/Match'
import Login from 'components/Login'
import Dashboard from 'components/Dashboard'
import Team from 'components/Team'
import Account from 'components/Account'

import TournamentList from 'components/tournament/List'
import TournamentShow from 'components/tournament/Show'
import RoundList from 'components/tournament/RoundList'
import TournamentTeamList from 'components/tournament/TeamList'
import TournamentEdit from 'components/tournament/Edit'
import TournamentDelete from 'components/tournament/Delete'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    redirect: '/dashboard',
  },
  {
    path: '/dashboard',
    component: Dashboard,
    redirect: '/dashboard/tournaments',
    children: [
      {
        path: 'tournaments',
        component: TournamentList,
      },
      {
        path: 'matches',
        component: MatchList,
      },
      {
        path: 'teams',
        component: TeamList,
      },
    ],
  },
  {
    path: '/account',
    component: Account,
  },
  {
    path: '/games',
    component: GameList,
  },
  {
    path: '/games/:id',
    name: 'games',
    component: Game,
    redirect: '/games/:id/tournaments',
    children: [
      {
        path: 'tournaments',
        name: 'game tournaments',
        component: TournamentList,
      },
      {
        path: 'matches',
        name: 'game matches',
        component: MatchList,
      },
      {
        path: 'edit',
        name: 'game edit',
        component: GameEdit,
      },
      {
        path: 'remove',
        name: 'game remove',
        component: GameRemove,
      },
    ],
  },
  {
    path: '/teams',
    component: TeamList,
  },
  {
    path: '/matches',
    component: MatchList,
  },
  {
    path: '/tournaments',
    component: TournamentList,
    // component: resolve => require(['./components/TournamentList', './components/Tournament'], resolve)
  },
  {
    path: '/tournaments/:id',
    name: 'tournament',
    component: TournamentShow,
    redirect: '/tournaments/:id/rounds',
    children: [
      {
        path: 'rounds',
        name: 'tournament rounds',
        component: RoundList,
      },
      {
        path: 'teams',
        name: 'tournament teams',
        component: TournamentTeamList,
      },
      {
        path: 'update',
        name: 'tournament update',
        component: TournamentEdit,
      },
      {
        path: 'delete',
        name: 'tournament delete',
        component: TournamentDelete,
      },
    ],
  },
  {
    path: '/login',
    component: Login,
  },
  {
    path: '/logout',
    redirect: '/login',
  },
  {
    path: '/matches/:id',
    name: 'match',
    component: Match,
  },
  {
    path: '/teams/:id',
    name: 'team',
    component: Team,
  },
]

export const router = new VueRouter({
  routes,
})

router.beforeEach((to, from, next) => {
  if(to.path === '/login') {
    if(store.getters.isLoggedIn) {
      next('/')
    } else {
      next()
    }
  } else if(!store.getters.isLoggedIn && !auth.getToken()) {
    next('/login')
  } else {
    next()
  }
})

export default router
