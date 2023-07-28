class ApplicationController < ActionController::Base
	include Pagy::Backend
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :authenticate_user!
	def after_sign_in_path_for(resource)
		current_user.admin? ? admin_users_path : root_path
	end

	private

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :fname, :lname, :avatar])	
		devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :fname, :lname, :email])
	end

	
end
