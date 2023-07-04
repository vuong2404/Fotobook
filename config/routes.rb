Rails.application.routes.draw do

  get '/feeds/photos', to: "photos#feed" 
  get '/feeds/albums', to: "albums#feed" 
  get '/discovery/albums', to: "albums#discovery" 
  get '/discovery/photos', to: "photos#discovery" 
  get 'photos/new/:id', to: "photos#create"
  get 'photos/update'
  get 'photos/delete'
  get 'albums/create'
  get 'albums/update'
  get 'albums/delete'
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  root "static_pages#home"

end