require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  namespace :api do
    namespace :v1 do
      mount ActionCable.server => "/cable"

      post "user_token" => "user_token#create"

      resources :users, only: [:create, :index, :update]

      resources :teams, only: [:create, :index, :show, :update]

      resources :matches, only: :update

      resources :friendly_matches, only: [:create, :index, :show, :update, :destroy] do
        resources :lineups, only: :update
      end

      resources :tournaments, only: [:create, :index, :show, :update, :destroy] do
        resources :lineups, only: [:update, :create, :destroy]
      end

      resources :games, only: [:create, :index, :show, :update, :destroy]
    end
  end
end
