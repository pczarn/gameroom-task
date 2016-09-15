Rails.application.routes.draw do
  root "sessions#new"

  resources :users, only: [:create]
  get "sign_up" => "users#new", as: "sign_up"

  resource :sessions, only: [:create]
  get "log_in" => "sessions#new", as: "log_in"
  delete "log_out" => "sessions#destroy", as: "log_out"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :matches, except: [:show]
end
