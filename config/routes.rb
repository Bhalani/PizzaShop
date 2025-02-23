Rails.application.routes.draw do
  namespace :vendors do
    resources :pizzas, except: [ :index, :show ]
    resources :inventories, except: [ :index, :show ]
    get "home", to: "home#index", as: "home"
  end

  namespace :customers do
    resources :orders, only: [ :new, :create, :show ] do
      resources :order_sides, only: [ :new, :create ]
    end
    get "home", to: "home#index", as: "home"
  end

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  root "home#index"
end
