Rails.application.routes.draw do
  get "borrowings/create"
  get "borrowings/destroy"
  get "books/index"
  get "books/show"
  get "/signup", to: "users#new"
  post "/users", to: "users#create"
  get "/users/:id", to: "users#show", as: "user"


  get "/login", to: "sessions#new", as: :new_session
  post "/login", to: "sessions#create", as: :session
  delete "/logout", to: "sessions#destroy", as: :logout

  root to: "books#index"
  resources :books do
    member do
      post "borrow"
      post "return"
    end
  end

  resources :borrowings, only: [ :index ] do
    collection do
      get "history"
      get "overdue"
      get "all", to: "borrowings#all_borrowings"
      get "all_overdue"
    end
  end

    get "my_borrowings", to: "borrowings#index"
  get "my_history", to: "borrowings#history"

  resources :passwords, param: :token

  get "up" => "rails/health#show", as: :rails_health_check
end
