class UsersController < ApplicationController
  skip_before_action :authenticate_user! , only: [:show]
  def show
    user_id = params[:id]
    page = params[:page] || "photos"

    puts params
    if User.exists?(user_id)
      user = User.find(user_id)
      @is_owner = current_user && current_user.id.to_i == user_id.to_i
      @is_followed = current_user && current_user.follow?(user_id)
      @photos = user.photos
      @albums = user.albums
      @followers = user.followers
      @followings = user.followings
      @profile_user_id = user.id
      @full_name = user.fname + " " + user.lname
      @avatar = user.avatar

    else
      render file: "#{Rails.root}/public/404.html", layout: true, status: :not_found
    end 
  end
  
  def follow
    following_user_id = params[:user_id]
    begin
        current_user.followings_connections.new(following_id: following_user_id.to_i)
        current_user.save!

        render :turbo_stream => turbo_stream.replace_all(
            ".follow_user#{following_user_id}",
            partial: 'shared/follow_button',
            locals: { profile_user_id: following_user_id, is_followed: true } )
    rescue  Exception => e
      render file: "#{Rails.root}/public/500.html", layout: true
    end
  end

  def unfollow
    following_user_id = params[:user_id]
    begin
      current_user.followings_connections.where(following_id: following_user_id.to_i).delete_all
      current_user.save!

      render :turbo_stream => turbo_stream.replace_all(
          ".follow_user#{following_user_id}",
          partial: 'shared/follow_button',
          locals: { profile_user_id: following_user_id, is_followed: false } )
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

end
