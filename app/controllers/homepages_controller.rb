class HomepagesController < ApplicationController
  def index
    if user_signed_in?
      @found_items = FoundItem.all.order(created_at: :desc)
      @lost_items = LostItem.all.order(created_at: :desc)
      @latest_found_item = FoundItem.order(created_at: :desc).first
      @latest_lost_item = LostItem.order(created_at: :desc).first
      @rest_found_items = FoundItem.where.not(id: @latest_found_item.id)
      @rest_lost_items = FoundItem.where.not(id: @latest_lost_item.id)
    end
  end
end
