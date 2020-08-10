class FollowingsController < ApplicationController
  before_action :logged_in_user, :find_user, only: :index

  def index
    @title = t "follow.following"
    @users = @user.followers.page(params[:page]).per Settings.list_users.pagination
    render "users/show_follow"
  end
end
