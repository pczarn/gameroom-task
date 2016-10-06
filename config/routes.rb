Rails.application.routes.draw do
  resources :users, only: [:create, :show, :update]

  resource :sessions, only: :create
  delete "log_out", to: "sessions#destroy", as: "log_out"

  resources :teams, only: [:create, :index, :show, :update]

  resources :matches, only: [:create, :index, :show, :update, :destroy]

  resources :tournaments, only: [:create, :index, :show, :update, :destroy]

  resources :team_tournament_participations, only: [:create, :destroy]

  resources :team_tournament_membership, only: [:create, :destroy]

  resources :games, only: [:create, :index, :show, :update, :destroy]
end
