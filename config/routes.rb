Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
  resources :static_pages, only: %i(home, help, about, contact)
  root "static_pages#home"
  get "home", to: "static_pages#home"
  get "help", to: "static_pages#help"
  get "about", to: "static_pages#about"
  get "contact", to: "static_pages#contact"
  resources :users, only: %i(new, create, show)
  get "signup", to: "users#new"
  post "/signup", to: "users#create"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  end
end
