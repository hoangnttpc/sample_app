class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "shared.email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t "shared.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t("shared.cant_be_empty")
      render :edit
    elsif @user.update user_params.merge reset_digest: nil
      log_in @user
      @user.update reset_digest: nil
      flash[:success] = t "shared.password_has_been_reset"
      redirect_to @user
    else
      flash[:danger] = t "shared.can_not_reset_password"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit User::RESET_PASSWORD_USERS_PARAMS
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "shared.user_not_found"
    redirect_to new_password_reset_url
  end

  def valid_user
    redirect_to root_url unless @user.activated? && @user.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "shared.password_reset_has_expired"
    redirect_to new_password_reset_url
  end
end
