class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_unread_notifications_count

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
    @unread_notifications_count = current_user.notifications.where(read: false).count
  end

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)

    @unread_notifications_count = current_user.notifications.where(read: false).count

    # Redirect logic only for the two allowed clickable types
    case notification.notifiable_type
    when "ThankYouNote"
      redirect_to profiles_path, notice: "Notification marked as read."
    when "Match"
      match = notification.notifiable
      if match&.lost_item.present?
        redirect_to lost_item_match_path(match.lost_item, match, step: 1),
                    notice: "Notification marked as read."
      else
        redirect_back fallback_location: notifications_path,
                      alert: "Match no longer available."
      end
    else
      redirect_back fallback_location: notifications_path,
                    alert: "This notification type is not clickable."
    end
  end

  def mark_all_as_read
    current_user.notifications.where(read: false).update_all(read: true)
    @unread_notifications_count = 0
    @notifications = current_user.notifications.order(created_at: :desc)

    respond_to do |format|
      format.html { redirect_back fallback_location: notifications_path }
      format.js
    end
  end

  private

  def set_unread_notifications_count
    @unread_notifications_count = current_user.notifications.where(read: false).count
  end
end
