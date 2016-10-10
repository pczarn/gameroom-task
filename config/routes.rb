Rails.application.routes.draw do
  root "matches#index"

  resources :users, only: [:create, :edit, :update]

  get "sign_up", to: "users#new", as: "sign_up"

  resource :sessions, only: [:create]
  get "log_in", to: "sessions#new", as: "log_in"
  delete "log_out", to: "sessions#destroy", as: "log_out"

  resources :teams do
    post :add_member
    delete :remove_member
  end

  resources :matches, except: :show

  resources :tournaments, except: [:new, :show]

  resources :team_tournament_participations, only: [:create, :destroy]

  resources :team_tournament_membership, only: [:create, :destroy]

  resources :games, except: :show
end
