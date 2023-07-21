class Admin::UsersController < AdminController
  def index
    @users = User.order(:created_at).page params[:page]
    render 'users/index'
  end

  def edit
    @user = User.find_by({id: params[:id]})
    render "users/edit"
  end

  def update 
    puts params
    if User.exists?(params[:id])
      if params[:user][:password].blank?
        puts "fdf"
        User.find(params[:id]).update(user_params_without_password)
      else
        
        puts "have password"
        User.find(params[:id]).update(user_params)
      end
      redirect_to admin_users_path
    end 
  end

  def destroy
    user = User.find(params[:id])
    user.destroy!
    redirect_to admin_users_path
  end

  private
    def user_params
      params.required(:user).permit(:email, :fname, :lname, :avatar, :password)
    end

    def user_params_without_password
      params.required(:user).permit(:email, :fname, :lname, :avatar)
    end
end

