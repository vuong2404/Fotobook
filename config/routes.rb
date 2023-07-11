Rails.application.routes.draw do
  root "home#feed"
  get  "/discovery", to: "home#discovery"

  get "/profile/:id", to: "profile#show", as: :profile

  post "follow/:user_id", to: "connections#create", as: :follow_user
  delete "unfollow/:user_id", to: "connections#destroy", as: :unfollow_user

  resources :photos, :albums, except: [:index, :show]
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations' 
  }


end