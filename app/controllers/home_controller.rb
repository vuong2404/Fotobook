class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:feed, :discovery, :search]
  layout "search/search_layout", only: [:search]
  def feed
    if current_user
      # show feed using following
      # lấy tất cả post(photo, albums) của user mà người đó follow
      followed_users = Connection.where(follower_id: current_user.id).pluck(:following_id)
      @photos = Photo.where(user_id: followed_users)
      @albums = Album.where(user_id: followed_users)      
    else
      
    end
    

  end

  def discovery
    @photos = Photo.order(created_at: :desc).limit(20)
    @albums = Album.order(created_at: :desc).limit(20)  
  end 


  def search 
    begin 
      if params[:key] && params[:key] != ""
        user_key = User.sanitize_sql_like(params[:key])
        post_key = Photo.sanitize_sql_like(params[:key])
        @key = params[:key]
        @users = User.where("fname LIKE ? OR lname LIKE ?", "%#{user_key}%", "%#{user_key}%").limit(3)
        @photos = Photo.where("title LIKE ? OR description LIKE ?", "%#{post_key}%", "%#{post_key}%").limit(2)
        @albums = Album.where("title LIKE ? OR description LIKE ?", "%#{post_key}%", "%#{post_key}%").limit(2)
        render "home/search", layout: "search/search_layout"
      else
        render :json => params
      end
    rescue Exception => e
      render :json => e
    end 
  end
end
