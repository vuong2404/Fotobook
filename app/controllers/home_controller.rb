class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:feed, :discovery]
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
  end
end
