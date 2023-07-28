class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:feed, :discovery, :search]
  layout "search/search_layout", only: [:search]
  def feed
    if current_user
      followed_users = Connection.where(follower_id: current_user.id).pluck(:following_id)
      @pagy, @photos = pagy(Photo.all.order(:created_at), items: 4)
      respond_to do |format|
        format.html 
        format.turbo_stream
      end
    else
      redirect_to discovery_path
    end
  end


  def feed_albums 
    if current_user
      followed_users = Connection.where(follower_id: current_user.id).pluck(:following_id)
      @pagy, @albums = pagy(Album.where(user_id: followed_users).order(:created_at), items: 4)
      respond_to do |format|
        format.html 
        format.turbo_stream
      end
    else
      redirect_to discovery_path
    end
  end

  def discovery
    @pagy, @photos = pagy(Photo.order(:created_at), items: 4)
    respond_to do |format|
      format.html 
      format.turbo_stream
    end
  end 


  def discovery_albums
    @pagy, @albums = pagy(Album.order(:created_at), items: 4)
    respond_to do |format|
      format.html 
      format.turbo_stream
    end
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
