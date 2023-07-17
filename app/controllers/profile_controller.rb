class ProfileController < ApplicationController
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

end
