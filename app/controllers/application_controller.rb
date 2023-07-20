class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :authenticate_user!

	private

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :fname, :lname, :avatar])
		devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :fname, :lname, :email])
	end

	def authenticate_admin!
		
	end
end
