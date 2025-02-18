Rails.application.routes.draw do
  get "/signup", to: "users#new"
  post "/users", to: "users#create"
  get "/users/:id", to: "users#show", as: "user"


  get "/login", to: "sessions#new", as: :new_session
  post "/login", to: "sessions#create", as: :session
  delete "/logout", to: "sessions#destroy", as: :logout

  root to: "users#new"

  resources :passwords, param: :token

  get "up" => "rails/health#show", as: :rails_health_check
end
