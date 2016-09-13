Rails.application.routes.draw do
  root "matches#index"

  resources :users, only: [:create]
  get "sign_up", to: "users#new", as: "sign_up"

  resource :sessions, only: [:create]
  get "log_in", to: "sessions#new", as: "log_in"
  delete "log_out", to: "sessions#destroy", as: "log_out"

  resources :teams

  resources :matches, except: :show

  resources :tournaments, only: [:index, :create]

  resources :games, except: :show
end
