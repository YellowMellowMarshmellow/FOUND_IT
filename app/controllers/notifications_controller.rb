class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_unread_notifications_count
  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    redirect_back fallback_location: notifications_path
  end

  private

  def set_unread_notifications_count
    @unread_notifications_count = current_user.notifications.where(read: false).count
  end
end
