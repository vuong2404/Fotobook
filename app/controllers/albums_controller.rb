class AlbumsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    if  Album.exists?(params[:id])
      @album = Album.find(params[:id])
    else
      render file: "#{Rails.root}/public/404.html", layout: true, status: :not_found 
    end
  end

  def new
    @album = Album.new
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
      redirect_to profile_path(current_user)
    rescue Exception => e
      render file: "#{Rails.root}/public/500.html", layout: true
    end

  end

  def edit
    if current_user.albums.exists?(params[:id].to_i)
      @album = current_user.albums.find(params[:id])
    else 
      render file: "#{Rails.root}/public/404.html", layout: true, status: :not_found 
    end
  end

  def search
    if params[:key] && params[:key] != ""
      key = Album.sanitize_sql_like(params[:key])
      @results = Album.where("title LIKE ? OR description LIKE ?", "%#{key}%", "%#{key}%").limit(20)
      render "albums/search_result",layout: 'search/search_layout'

    else
      render :html => "Must have a key to search!"
    end
  end

  private
    def album_params
      params.required(:album).permit(:title, :description, :sharing_mode)
      # params.permit(images: [])
    end 
end
