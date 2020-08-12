class ApplicationController < ActionController::Base
  include SessionsHelper

  around_action :switch_locale

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "shared.please_log_in"
    redirect_to login_url
  end

  def switch_locale &action
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "shared.user_not_found"
    redirect_to root_url
  end
end
