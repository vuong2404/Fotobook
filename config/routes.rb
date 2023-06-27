Rails.application.routes.draw do
  get 'users/index'
  get 'user/index'
  root "users#index"

  get "/users", to: "users#index"
end