class SessionsController < ApplicationController
  before_action :find_user, :authenticate_user, only: %i(create)

  def new; end

  def create
    reset_session
    log_in @user
    if params.dig(:session,
                  :remember_me) == Settings.value_create
      remember(@user)
    else
      forget(@user)
    end
    redirect_to @user, status: :see_other
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

  private

  def find_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
    return if @user

    flash.now[:danger] = t("error.user_not_found")
    render :new, status: :unprocessable_entity
  end

  def authenticate_user
    return if @user.authenticate(params.dig(:session, :password))

    flash.now[:danger] = t("error.invalid_email_password_combination")
    render :new, status: :unprocessable_entity
  end
end
