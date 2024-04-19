class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("activerecord.flash.warning")
    redirect_to root_path
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
  private
  def user_params
    params.require(:user).permit User::Attributes
  end
end
