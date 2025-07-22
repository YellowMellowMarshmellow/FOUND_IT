class HomepagesController < ApplicationController
  before_action :load_notifications
  def index
    if user_signed_in?
      @found_items = FoundItem.all.order(created_at: :desc)
      @lost_items = LostItem.all.order(created_at: :desc)
      @notifications = current_user.notifications.order(created_at: :desc)
      @unread_count = current_user.notifications.where(read: false).count

      @latest_found_item = @found_items.first
      @latest_lost_item = @lost_items.first

      @rest_found_items = @latest_found_item.present? ? @found_items.where.not(id: @latest_found_item.id) : @found_items
      @rest_lost_items  = @latest_lost_item.present?  ? @lost_items.where.not(id: @latest_lost_item.id)  : @lost_items
    end
  end

  def load_notifications
    if current_user
      @unread_notifications_count = current_user.notifications.unread.count
      @notifications = current_user.notifications.order(created_at: :desc)
    end
  end
end
