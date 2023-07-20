class PhotosController < ApplicationController
  skip_before_action :authenticate_user! , only: [:show]

  def show
    if Photo.exists?(params[:id])
      @photo = Photo.find(params[:id])
    else
      render file: "#{Rails.root}/public/404.html", layout: true, status: :not_found 
    end
  end

  def create
    begin
      current_user.photos.create!(photo_params)
      redirect_to profile_path(current_user)
    rescue Exception => e
      render file: "#{Rails.root}/public/500.html", layout: true
    end
  end

  def new 
    @photo = Photo.new
  end

  def update
    begin
      if params[:delete]
        current_user.photos.find(params[:id].to_i).destroy
      else 
        current_user.photos.find(params[:id]).update(photo_params)
      end
      redirect_to profile_path(current_user)
    rescue Exception => e
      render :json => {params: params[:photo], error: e}
    end
  end 

  def edit
    if current_user.photos.exists?(params[:id].to_i)
      @photo = current_user.photos.find(params[:id])
    else 
      render file: "#{Rails.root}/public/404.html", layout: true, status: :not_found 
    end
  end

  private
    def photo_params
      params.required(:photo).permit(:title, :description, :image, :sharing_mode)
    end 
  
end
