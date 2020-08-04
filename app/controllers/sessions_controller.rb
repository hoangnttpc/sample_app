class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      flash[:success] = t ".success_login"
      redirect_to user
    else
      flash[:danger] = t ".error_login"
      render :new
    end
  end

  def destroy; end
end
