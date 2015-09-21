class SessionsController < ApplicationController

  def new
    redirect_to categories_path if logged_in?
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash[:danger] = 'Incorrect username or password. Try again'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end