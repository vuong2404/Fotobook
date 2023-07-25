class Admin::AlbumsController < AdminController
	def index
		@albums = Album.order(:created_at).page params[:page]
		render "albums/index"
	end

	def update
		begin
      ActiveRecord::Base.transaction do
        params[:delete] ? Album.find(params[:id].to_i).destroy : update_album(params)
      end
      redirect_to admin_albums_path(current_user)
    rescue Exception => e
      # render file: "#{Rails.root}/public/500.html", layout: false
      render :json => {error: e, params: params}
    end
	end

	def edit
		if Album.exists?(params[:id])
			@album = Album.find(params[:id])
		else
			render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
		end
	end

	def destroy
		if Album.exists?(params[:id])
			@album = Album.find(params[:id])
			redirect_to admin_albums_path
		else
			render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
		end
	end

	private
    def album_params
      params.required(:album).permit(:title, :description, :sharing_mode)
    end 

    def update_album(params)
      # update albums
      album = Album.find(params[:id])
      album.update(album_params)

      # create new photos
      params[:images].each do |image|
        next if image == ""
        photo = Photo.new(album_params)
        photo.image.attach(image)
        photo.user_id = album.user_id
        album.photos << photo
      end

      
      # delete photos
      params[:photos_delete] && params[:photos_delete].each do |id|
        id = id.to_i 
        album.photos.exists?(id) && album.photos.find(id).destroy
      end
    end 
end
