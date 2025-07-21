class HomepagesController < ApplicationController
  def index
    if user_signed_in?
      @found_items = FoundItem.all.order(created_at: :desc)
      @lost_items = LostItem.all.order(created_at: :desc)

      @latest_found_item = @found_items.first
      @latest_lost_item = @lost_items.first

      @rest_found_items = @latest_found_item.present? ? @found_items.where.not(id: @latest_found_item.id) : @found_items
      @rest_lost_items  = @latest_lost_item.present?  ? @lost_items.where.not(id: @latest_lost_item.id)  : @lost_items
    end
  end
end
