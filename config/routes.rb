Rails.application.routes.draw do
  root "matches#index"

  resources :users, only: [:create, :edit, :update]

  get "sign_up", to: "users#new", as: "sign_up"

  resource :sessions, only: [:create]
  get "log_in", to: "sessions#new", as: "log_in"
  delete "log_out", to: "sessions#destroy", as: "log_out"

  resources :teams, only: [:create, :index, :edit, :update]

  resources :matches, only: [:create, :index, :edit, :update, :destroy]

  resources :tournaments, only: [:create, :index, :edit, :update, :destroy]

  resources :team_tournament_participations, only: [:create, :destroy]

  resources :team_tournament_membership, only: [:create, :destroy]

  resources :games, only: [:create, :index, :edit, :update, :destroy]
end
