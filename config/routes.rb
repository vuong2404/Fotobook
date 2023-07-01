Rails.application.routes.draw do
  root "static_pages#home"

  get "/users", to: "users#index"
end