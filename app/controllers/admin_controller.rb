class AdminController < ApplicationController
	before_action :authenticate_admin
  private
  def authenticate_admin
    unless current_user && current_user.is_admin? 
      render file: "#{Rails.root}/public/403.html", layout: false, status: :forbidden
    end 
  end
end 