class ConnectionsController < ApplicationController
    #follow
    def create
        following_user_id = params[:user_id]
        begin
            current_user.followings_connections.new(following_id: following_user_id.to_i)
            current_user.save!

            render :turbo_stream => turbo_stream.replace_all(
                ".follow_user#{following_user_id}",
                partial: 'shared/follow_button',
                locals: { profile_user_id: following_user_id, is_followed: true } )
        rescue  Exception => e
            puts "Somthing went wrong!"
        end
    end


    # #Unfollow
    def destroy
        following_user_id = params[:user_id]
        begin
            current_user.followings_connections.where(following_id: following_user_id.to_i).delete_all
            current_user.save!

            render :turbo_stream => turbo_stream.replace_all(
                ".follow_user#{following_user_id}",
                partial: 'shared/follow_button',
                locals: { profile_user_id: following_user_id, is_followed: false } )
        rescue  Exception => e
            puts "Somthing went wrong!"
        end
    end
end
