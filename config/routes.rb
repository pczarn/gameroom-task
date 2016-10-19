Rails.application.routes.draw do
  root to: "root#index"

  namespace :api do
    namespace :v1 do
      post "user_token" => "user_token#create"

      resources :users, only: [:create, :index, :update]

      resources :teams, only: [:create, :index, :show, :update]

      resources :matches, only: [:create, :index, :show, :update, :destroy]

      resources :tournaments, only: [:create, :index, :show, :update, :destroy]

      resources :team_tournament_participations, only: [:create, :destroy]

      resources :team_tournament_membership, only: [:create, :destroy]

      resources :games, only: [:create, :index, :show, :update, :destroy]
    end
  end
end
