class UsersController < ApplicationController
  skip_before_action :authenticate_user! , only: [:show, :show_albums, :show_followings, :show_followers, :search]
  before_action :get_user, :only => [:show,:show_albums, :show_followings, :show_followers]

  layout "profile/profile_layout", only: [:show,:show_albums, :show_followings, :show_followers]
  
  def show
    @photos = @user.photos
  end

  def show_albums
    @albums = @user.albums
  end 
  
  def show_followings
    @followings = @user.followings
  end 

  def show_followers
    @followers = @user.followers
  end 
  
  def follow
    @user = User.exists?(params[:user_id]) && User.find(params[:user_id])
    begin
      current_user.followings_connections.new(following_id: @user.id)
      current_user.save!
      render :turbo_stream => turbo_stream.replace_all(
                              ".follow_user#{@user.id}",
                              partial: 'shared/follow_button',
                              locals: { user: @user } )
    rescue  Exception => e
      render :json => e
      # render file: "#{Rails.root}/public/500.html", layout: true
    end
  end

  def unfollow
    @user = User.exists?(params[:user_id]) && User.find(params[:user_id])
    begin
      current_user.followings_connections.where(following_id: @user.id).delete_all
      current_user.save!

      render :turbo_stream => turbo_stream.replace_all(
          ".follow_user#{@user.id}",
          partial: 'shared/follow_button',
          locals: { user: @user} )
    rescue  Exception => e
      render file: "#{Rails.root}/public/500.html", layout: true
    end
  end

  def like
    respond_to do |format|
      unless ['photos', 'albums'].include?(params[:post_type])
        format.json { render json: { error: "Invalid post_type" }, status: :unprocessable_entity }
      else
        post_type = (params[:post_type] == 'photos') ? Photo : Album
        current_user.likes.new({likeable_id: params[:post_id], likeable_type: post_type })
        post = post_type.find(params[:post_id])
        if current_user.save!
          format.turbo_stream do
            render :turbo_stream => turbo_stream.replace(
              "like_post_#{params[:post_id]}",
              partial: 'shared/like_button',
              locals: { post: post } )
          end
        else 
          format.json { render json:  {error: like.errors, params: params} }
        end
      end 
    end 
  end

  def unlike
    respond_to do |format|
      unless ['photos', 'albums'].include?(params[:post_type])
        format.json { render json: { error: "Invalid post_type" }, status: :unprocessable_entity }
      else
        post_type = (params[:post_type] == 'photos') ? Photo : Album
        current_user.likes.where(likeable_id: params[:post_id], likeable_type: post_type.to_s).delete_all
        post = post_type.find(params[:post_id])
        
        if current_user.save!
          format.turbo_stream do
            render :turbo_stream => turbo_stream.replace(
              "like_post_#{params[:post_id]}",
              partial: 'shared/like_button',
              locals: { post: post } )
          end
        else 
          format.json { render json:  {error: like.errors, params: params} }
        end
      end 
    end 
  end

  def search
    if params[:key] && params[:key] != ""
      key = User.sanitize_sql_like(params[:key])
      @results = User.where("fname LIKE ? OR lname LIKE ?", "%#{key}%", "%#{key}%").limit(20)
      render "users/search_result", layout: "search/search_layout"
    else
      render :html => "Must have a key to search!"
    end
  end


  private
    def get_user
      if User.exists?(params[:id])
        @user = User.find(params[:id])
        if current_user 
          @is_owner = @user.id == current_user.id
        end
      else 
        render file: "#{Rails.root}/public/404.html", layout: true, status: :not_found
      end
    end

end
