class PhotosController < ApplicationController
  def index
		@photos = Album.limit(20)
		render "photos/index"
	end

  def update
		if Photo.exists?(params[:id])
			begin
				params[:delete] ? Photo.find(params[:id].to_i).destroy :
													Photo.find(params[:id]).update(photo_params)
				redirect_to admin_photos_path
			rescue Exception => e
				render file: "#{Rails.root}/public/500.html", layout: true
			end
		else 
      render file: "#{Rails.root}/public/404.html", layout: true, status: :not_found 
		end
  end 

  def edit
    if Photo.exists?(params[:id].to_i)
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
