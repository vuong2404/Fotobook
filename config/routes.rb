Rails.application.routes.draw do
  root to: "home#feed"

  get  "/feeds/albums", to: "home#feed_albums", as: :feed_albums
  get  "/discovery", to: "home#discovery", as: :discovery
  get  "/discovery/albums", to: "home#discovery_albums", as: :discovery_albums

  post "follow/:user_id", to: "users#follow", as: :follow_user
  delete "unfollow/:user_id", to: "users#unfollow", as: :unfollow_user

  post "likes/:post_type/:post_id", to: "users#like", as: :like_post
  delete "likes/:post_type/:post_id", to: "users#unlike", as: :dislike_post
  
  scope "/profile/:id" do 
    get "/", to: "users#show", as: :profile
    get "/albums", to: "users#show_albums", as: :profile_albums
    get "/followings", to: "users#show_followings", as: :profile_followings
    get "/followers", to: "users#show_followers",  as: :profile_followers
  end

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