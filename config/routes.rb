Rails.application.routes.draw do
  get "password_resets/new"
  get "password_resets/edit"
  get "password_resets/create"
  get "password_resets/update"
  scope "(:locale)", locale: /en|vi/ do
  resources :static_pages, only: %i(home, help, about, contact)
  root "static_pages#home"
  get "home", to: "static_pages#home"
  get "help", to: "static_pages#help"
  get "about", to: "static_pages#about"
  get "contact", to: "static_pages#contact"
  resources :users
  get "signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users do
    member do
      get :following, :followers
      end
    end
  resources :account_activations, only: :edit
  resources :password_resets, only: %i(new create edit update)
  resources :microposts, only: %i(create destroy)
  resources :relationships, only: %i(create destroy)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  end
end
