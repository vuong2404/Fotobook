class ConnectionsController < ApplicationController

    #follow
    def create
        following_user_id = params[:user_id]
        begin
            current_user.followings_connections.new(following_id: following_user_id.to_i)
            current_user.save!

            redirect_to profile_path(following_user_id)
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

            redirect_to profile_path(following_user_id)
        rescue  Exception => e
            puts "Somthing went wrong!"
        end
    end
end
