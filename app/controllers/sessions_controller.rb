class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      user_authenticated_handle user
    else
      flash[:danger] = t ".error_login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def user_authenticated_handle user
    if user.activated?
      log_in user
      if params[:session][:remember_me] == Settings.sessions.create.select_box
        remember user
      else
        forget user
      end
      flash[:success] = t ".success_login"
      redirect_back_or user
    else
      flash[:warning] = t "shared.account_not_activated"
      redirect_to root_url
    end
  end
end
