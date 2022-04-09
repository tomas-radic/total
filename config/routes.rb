Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # root to: "today#index"
  root to: "players#index"

  devise_for :player,
             controllers: {
               sessions: "player/sessions",
               registrations: "player/registrations"
             }

  get "/today", to: "today#index", as: "today"
  get "/rankings", to: "rankings#index", as: "rankings"
  get "/about", to: "pages#about", as: "about"

  resources :tournaments, only: [:index, :show]
  resources :matches, only: [:index, :show]
  resources :players, only: [:index, :show]
  resources :articles, only: [:index, :show]


  namespace :player do
    resources :matches, only: [:create, :edit, :update, :destroy] do
      post :accept, on: :member
      post :reject, on: :member
      get :finish_init, on: :member
      post :finish, on: :member
      post :toggle_reaction, on: :member
    end

    post "players/toggle_open_to_play"
    post "players/anonymize"
  end


  # MANAGERS --------------------------------- (begin)

  devise_for :manager,
             controllers: {
               sessions: "manager/sessions",
               registrations: "manager/registrations"
             }

  namespace :manager do
    root to: "pages#dashboard"

    get "pages/dashboard"

    resources :seasons, only: [:new, :create, :edit, :update]

    resources :players, only: [:edit, :update] do
      post :toggle_access, on: :member
    end

    post "enrollments/toggle", to: "enrollments#toggle", as: "toggle_enrollment"
  end

  # MANAGERS --------------------------------- (end)
end
