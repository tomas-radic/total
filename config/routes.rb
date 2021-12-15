Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "today#index"
  devise_for :player,
             controllers: {
               sessions: "player/sessions",
               registrations: "player/registrations"
             }

  get "/today", to: "today#index", as: "today"
  get "/rankings", to: "rankings#index", as: "rankings"

  resources :tournaments, only: [:index, :show]
  resources :matches, only: [:index, :show]
  resources :players, only: [:show]


  namespace :player do
    resources :matches, only: [:create, :edit, :update, :destroy] do
      post :accept, on: :member
      post :reject, on: :member
      get :finish_init, on: :member
      post :finish, on: :member
    end

    post "players/toggle_open_to_play"
    post "players/anonymize"
  end

end
