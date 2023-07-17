class AlbumsController < ApplicationController
  def index
  end

  def show
    @album = Album.find(params[:id])
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        album = current_user.albums.new(album_params)
        album.save
        params[:images].each do |image|
          next if image == ""
          photo = current_user.photos.create(album_params)
          photo.image.attach(image)
          album.photos << photo
        end
      end
    # render :json => params
    redirect_to profile_path(current_user)
    rescue Exception => e
      render json: e
    end
  end
  

  def update
    begin
      ActiveRecord::Base.transaction do
        if params[:delete]
          #delete album
          current_user.albums.find(params[:id].to_i).destroy
        else 
          # update albums
          album = current_user.albums.find(params[:id])
          album.update(album_params)

          # create new photos
          params[:images].each do |image|
            next if image == ""
            photo = current_user.photos.create(album_params)
            photo.image.attach(image)
            album.photos << photo
          end
          
          # delete photos
          params[:photos_delete] && params[:photos_delete].each do |id|
            id = id.to_i 
            album.photos.exists?(id) && album.photos.find(id).destroy
          end
        end
      end
    # render :json => params
    redirect_to profile_path(current_user)
    rescue Exception => e
      render :json => {params: params[:photo], error: e}
    end


    # render :json => params
  end

  def edit
    if current_user.albums.exists?(params[:id].to_i)
      @album = current_user.albums.find(params[:id])
    else 
      render file: "#{Rails.root}/public/404.html", layout: true, status: :not_found 
    end
  end

  def new
  end


  private
    def album_params
      params.required(:album).permit(:title, :description, :sharing_mode)
      # params.permit(images: [])
    end 
end
