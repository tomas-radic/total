Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "today#index"

  get "/today", to: "today#index", as: "today"

  resources :tournaments, only: [:index, :show]

end
