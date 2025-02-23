# application_controller.rb content from the old app
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_role, :logged_in?

  def current_role
    session[:role]
  end

  def logged_in?
    current_role.present?
  end

  def require_user
    redirect_to login_path, alert: "You must be logged in to access this page" unless logged_in?
  end

  def require_vendor
    redirect_to root_path, alert: "You do not have permission to access this page" unless current_role == "vendor"
  end
end
