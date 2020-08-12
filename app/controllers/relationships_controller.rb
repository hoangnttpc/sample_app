class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_create_relationship, only: :create
  before_action :find_destroy_relationship, only: :destroy

  def create
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def check_user_blank
    return if @user

    flash[:danger] = t ".user_not_exist"
    redirect_to root_path
  end

  def find_create_relationship
    @user = User.find_by id: params[:followed_id]
  end

  def find_destroy_relationship
    @user = Relationship.find_by(id: params[:id]).followed
  end
end
