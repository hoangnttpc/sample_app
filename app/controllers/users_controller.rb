class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :show, :create]
  before_action :find_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.list_users.pagination
  end

  def show
    @microposts = @user.microposts.page(params[:page]).per Settings.items_per_pages
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:success] = t ".success_mess"
      redirect_to @user
    else
      flash[:danger] = t ".fail_mess_create"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".success_mess"
      redirect_to @user
    else
      flash[:danger] = t ".fail_mess"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".delete_danger"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
