class LikesController < ApplicationController
  def create
    respond_to do |format|
      unless ['photos', 'albums'].include?(params[:post_type])
        format.json { render json: { error: "Invalid post_type" }, status: :unprocessable_entity }
      else
        post_type = (params[:post_type] == 'photos') ? Photo : Album
        like = current_user.likes.new({likeable_id: params[:post_id], likeable_type: post_type })
        if like.save!
          format.html {redirect_to request.referer}
        else 
          format.json { render json:  {error: like.errors, params: params} }
        end
      end 
    end 
  end

  def destroy
    respond_to do |format|
      unless ['photos', 'albums'].include?(params[:post_type])
        format.json { render json: { error: "Invalid post_type" }, status: :unprocessable_entity }
      else
        post_type = (params[:post_type] == 'photos') ? "Photo" : "Album"
        
        current_user.likes.where(likeable_id: params[:post_id], likeable_type: post_type).delete_all

        if current_user.save!
          format.html {redirect_to request.referer}
        else 
          format.json { render json:  {error: like.errors, params: params} }
        end
      end 
    end 
  end
end
