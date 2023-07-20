Rails.application.routes.draw do
  root "home#feed"
  get  "/discovery", to: "home#discovery"
  get "/profile/:id", to: "users#show", as: :profile

  post "follow/:user_id", to: "users#follow", as: :follow_user
  delete "unfollow/:user_id", to: "users#unfollow", as: :unfollow_user

  post "likes/:post_type/:post_id", to: "users#like", as: :like_post
  delete "likes/:post_type/:post_id", to: "users#unlike", as: :dislike_post

  resources :photos, except: [:index, :destroy]
  resources :albums, except: [:index, :destroy]
  namespace :admin do
    resources :photos, only: [:index, :update, :edit]
    resources :albums, only: [:index, :update, :edit]
    resources :users, except: [:create, :new]
  end 

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations' 
  }

  


end