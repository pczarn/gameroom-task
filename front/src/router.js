import Vue from 'vue'
import VueRouter from 'vue-router'

import store from 'src/store'
import auth from 'src/auth'

import GameList from 'components/game/List'
import Game from 'components/game/Show'
import GameEdit from 'components/game/Edit'
import GameRemove from 'components/game/Remove'

import TeamList from 'components/team/List'
import Team from 'components/team/Show'

import MatchList from 'components/match/List'
import Match from 'components/match/Show'
import MatchDetails from 'components/match/Details'
import MatchEdit from 'components/match/Edit'
import MatchDelete from 'components/match/Delete'

import Login from 'components/Login'
import Dashboard from 'components/Dashboard'
import AccountEdit from 'components/account/Edit'

const TournamentList =
  r => require.ensure([], _ => r(require('components/tournament/List')), 'tournaments')
const TournamentShow =
  r => require.ensure([], _ => r(require('components/tournament/Show')), 'tournaments')
const RoundList =
  r => require.ensure([], _ => r(require('components/tournament/RoundList')), 'tournaments')
const TournamentTeamList =
  r => require.ensure([], _ => r(require('components/tournament/TeamList')), 'tournaments')
const TournamentEdit =
  r => require.ensure([], _ => r(require('components/tournament/Edit')), 'tournaments')
const TournamentDelete =
  r => require.ensure([], _ => r(require('components/tournament/Delete')), 'tournaments')

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
    component: AccountEdit,
  },
  {
    path: '/games',
    component: GameList,
  },
  {
    path: '/games/:id',
    name: 'game',
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
    redirect: { name: 'match details' },
    children: [
      {
        path: '',
        name: 'match details',
        component: MatchDetails,
      },
      {
        path: 'edit',
        name: 'match edit',
        component: MatchEdit,
      },
      {
        path: 'delete',
        name: 'match delete',
        component: MatchDelete,
      },
    ],
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
