class HomepagesController < ApplicationController
  before_action :load_notifications

  def index
    if user_signed_in?
      @my_found_item_matches = Match
        .includes(:lost_item, :found_item)
        .where(found_item: current_user.found_items)

      @my_lost_item_matches = Match
        .includes(:lost_item, :found_item)
        .where(lost_item: current_user.lost_items)

      @found_items = current_user.found_items.order(created_at: :desc)
      @lost_items  = current_user.lost_items.order(created_at: :desc)

      #@notifications and @unread_count are already defined in load_notifications method below
      #@notifications = current_user.notifications.order(created_at: :desc)
      #@unread_count = current_user.notifications.where(read: false).count

      @latest_found_item = @found_items.first
      @latest_lost_item  = @lost_items.first

      if @latest_found_item
        @latest_found_item_match = @latest_found_item.matches.find { |m| m.lost_item.user_id == current_user.id }
        @latest_found_item_matched = @latest_found_item_match.present?
      end

      if @latest_lost_item
        @latest_lost_item_match = @latest_lost_item.matches.first
        @latest_lost_item_matched = @latest_lost_item_match.present?
      end


      @rest_found_items = @latest_found_item.present? ? @found_items.where.not(id: @latest_found_item.id) : @found_items
      @rest_lost_items  = @latest_lost_item.present?  ? @lost_items.where.not(id: @latest_lost_item.id) : @lost_items
    end
  end

  def load_notifications
    if current_user
      @unread_notifications_count = current_user.notifications.unread.count
      @notifications = current_user.notifications.order(created_at: :desc)
    end
  end
end
