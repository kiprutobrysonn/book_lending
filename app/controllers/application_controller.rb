class ApplicationController < ActionController::Base
  include Authentication
  helper_method :current_user, :ensure_admin!

  def current_user
    @current_user =Current.user
  end

  def ensure_admin
    unless current_user&.has_role?("admin")
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to books_path
    end
  end


  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
