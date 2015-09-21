class UsersController < ApplicationController

  def new
    redirect_to categories_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "#{@user.full_name}, your new account has been registered"
      redirect_to login_path
    else
      render :new
    end
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end