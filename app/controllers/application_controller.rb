class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_notifications, if: :user_signed_in?

  protected

  def after_sign_in_path_for(resource)
    root_path
  end

  def configure_permitted_parameters
    added_attrs = [:first_name, :last_name, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  private

  def set_notifications
    @notifications = current_user.notifications.order(created_at: :desc)
    @unread_notifications_count = @notifications.where(read: false).count
  end
end
