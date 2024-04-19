class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show create new)
  before_action :load_user, except: %i(index create new)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("activerecord.flash.warning")
    redirect_to root_path
  end

  def index
    @pagy, @users = pagy(User.order_by_name, items: Settings.items_per_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t("activerecord.flash.success")
      redirect_to @user
    else
      flash[:error] = t("activerecord.flash.error")
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t("edit.success")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("delete.success")
    else
      flash[:danger] = t("flashes.danger.user_not_deleted")
    end
    redirect_to users_path
  end

  private
  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("error.user_not_found")
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit User::Attributes
  end

  def correct_user
    return if current_user?(@user)

    flash[:error] = t("edit.correct_user")
    redirect_to root_url
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
