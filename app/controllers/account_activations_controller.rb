class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user&.authenticated?(:activation, params[:id]) && !user.activated?
      user.activate
      log_in user
      flash[:success] = t "shared.account_activated"
      redirect_to user
    else
      flash[:danger] = t "shared.invalid_activation_link"
      redirect_to root_url
    end
  end
end
