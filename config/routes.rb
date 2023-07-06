Rails.application.routes.draw do
  get "profile/:id", to: "profile#show", as: :profile

  post "follow/:user_id", to: "connections#create", as: :follow_user
  delete "unfollow/:user_id", to: "connections#destroy", as: :unfollow_user

  resources :photos, :albums
  devise_for :users, controllers: {
    sessions: 'users/sessions',
  }
  root "home#feed"

end