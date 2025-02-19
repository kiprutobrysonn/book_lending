class UsersController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]
  before_action :ensure_admin!, only: [ :show ]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
    @user.roles << Role.find_by(name: "user")
      redirect_to new_session_path, notice: "Account created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end

  def ensure_admin!
    unless Current.user.has_role?("admin")
      flash[:alert] = "You are not authorized to view this page."
      redirect_to books_path
    end
  end
end
