class FoundItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_found_item, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @found_items = FoundItem.all
  end

  def show
  end

  def new
    @found_item = FoundItem.new
  end

  def create
    @found_item = FoundItem.new(found_item_params)
    @found_item.user = current_user

    if @found_item.save
      LostItem.where(category: @found_item.category, location: @found_item.location).find_each do |lost_item|
        Match.create!(lost_item: lost_item, found_item: @found_item)

        Notification.create!(
          user: lost_item.user,
          message: "A potential match has been found for your lost object : #{lost_item.title}. Please confirm."
        )
      end

      redirect_to root_path, notice: "Found item reported successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @found_item.update(found_item_params)
      redirect_to @found_item, notice: "Found item updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @found_item.destroy
    redirect_to found_items_path, notice: "Found item deleted."
  end

  def my_reports
    @found_items = current_user.found_items.includes(:matches)
  end

  private

  def set_found_item
    @found_item = FoundItem.find(params[:id])
  end

  def authorize_user!
    unless @found_item.user == current_user
      redirect_to found_items_path, alert: "You are not authorized to edit this item."
    end
  end

  def found_item_params
    params.require(:found_item).permit(:title, :description, :category, :location, :date_reported, images: [])
  end

  def find_matches_for(found_item)
    possible_lost_items = LostItem.where(category: found_item.category, location: found_item.location)
    possible_lost_items.each do |lost_item|
      Match.create(found_item: found_item, lost_item: lost_item)
    end
  end
end
