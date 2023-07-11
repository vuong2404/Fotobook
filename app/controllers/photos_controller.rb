class PhotosController < ApplicationController
  skip_before_action :authenticate_user! , only: [:index]
  def index
    @photos = Photo.all
  end

  def create
    begin
      puts current_user
      current_user.photos.create!(photo_params)
      redirect_to profile_path(current_user)
    rescue Exception => e
      puts e   
    end
  end

  def update
  end 


  private
    def photo_params
      params.required(:photo).permit(:title, :description, :image, :sharing_mode)
    end 
  
end
