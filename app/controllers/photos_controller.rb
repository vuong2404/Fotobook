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
      current_user.photos.create(photo_params)
      redirect_to profile_path(current_user)
    rescue Exception => e
      render :json => params
      # format.html  {render file: "#{Rails.root}/public/500.html", layout: true}
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

  def search
    if params[:key] && params[:key] != ""
      key = Photo.sanitize_sql_like(params[:key])
      @results = Photo.where("title LIKE ? OR description LIKE ?", "%#{key}%", "%#{key}%").limit(20)
      render "photos/search_result", layout: 'search/search_layout'
    else
      render :html => "Must have a key to search!"
    end
  end

  private
    def photo_params
      params.required(:photo).permit(:title, :description, :image, :sharing_mode)
    end 
  
end
