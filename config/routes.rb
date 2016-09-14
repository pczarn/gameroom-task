Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/matches/:id", to: "matches#edit", as: "match"
  resources :matches, except: [:edit, :show]
end
