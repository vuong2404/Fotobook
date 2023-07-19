class LikesController < ApplicationController
  def create
    respond_to do |format|
      unless ['photos', 'albums'].include?(params[:post_type])
        format.json { render json: { error: "Invalid post_type" }, status: :unprocessable_entity }
      else
        post_type = (params[:post_type] == 'photos') ? Photo : Album
        current_user.likes.new({likeable_id: params[:post_id], likeable_type: post_type })
        post = post_type.find(params[:post_id])
        if current_user.save!
          format.turbo_stream do
            render :turbo_stream => turbo_stream.replace(
              "like_post_#{params[:post_id]}",
              partial: 'shared/like_button',
              locals: { post: post } )
          end
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
        post_type = (params[:post_type] == 'photos') ? Photo : Album
        current_user.likes.where(likeable_id: params[:post_id], likeable_type: post_type.to_s).delete_all
        post = post_type.find(params[:post_id])
        
        if current_user.save!
          format.turbo_stream do
            render :turbo_stream => turbo_stream.replace(
              "like_post_#{params[:post_id]}",
              partial: 'shared/like_button',
              locals: { post: post } )
          end
        else 
          format.json { render json:  {error: like.errors, params: params} }
        end
      end 
    end 
  end

end
