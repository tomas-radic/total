Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "today#index"
  devise_for :players

  get "/today", to: "today#index", as: "today"
  get "/rankings", to: "rankings#index", as: "rankings"

  resources :tournaments, only: [:index, :show]
  resources :matches, only: [:index]
  resources :players, only: [:show]


  namespace :player do
    resources :matches, only: [:create, :edit, :update]
  end

end
