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
    root  "users#index", as: "admin"  
    resources :photos, only: [:index, :update, :edit]
    resources :albums, only: [:index, :update, :edit]
    resources :users, except: [:create, :new]
  end 

  scope "/search" do 
    get '/all', to: "home#search",  as: "search"
    get '/photos', to: "photos#search", as: "search_photos"
    get '/albums', to: "albums#search", as: "search_albums"
    get '/users', to: "users#search",  as: "search_users"
  end 

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations' ,
    omniauth_callbacks: "users/omniauth_callbacks",
  }

end