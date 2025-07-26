class LostItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @lost_items = LostItem.all
    # The `geocoded` scope filters only lost items with coordinates:
    @markers = @lost_items.geocoded.map do |lost_item|
      {
        lat: lost_item.latitude,
        lng: lost_item.longitude
      }
    end
  end

  def show
    @lost_item = LostItem.find(params[:id])
    @match = @lost_item.matches.first
  end

  def new
    @lost_item = LostItem.new
  end

  def create
    @lost_item = LostItem.new(lost_item_params)
    @lost_item.user = current_user

    if @lost_item.save
      FoundItem.where(category: @lost_item.category)
                .near([@lost_item.latitude, @lost_item.longitude], 5, units: :mi)
                .find_each do |found_item|

         if openai_description_match?(found_item.description, @lost_item.description)
          match = Match.create!(lost_item: @lost_item, found_item: found_item)

          Notification.create!(
            user: @lost_item.user,
            message: "A found item matched your lost item. : #{found_item.title}",
            notifiable: match
          )
         end
      end
      redirect_to root_path, notice: "Lost item reported successfully."
    end
  end


  def edit
    @lost_item = LostItem.find(params[:id])
  end

  def update
    @lost_item = LostItem.find(params[:id])
    if @lost_item.update(lost_item_params)
      redirect_to @lost_item, notice: "Lost item updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @lost_item = LostItem.find(params[:id])
    @lost_item.destroy
    redirect_to lost_items_path, notice: "Lost item deleted."
  end

  def my_reports
    @my_lost_items = current_user.lost_items.includes(:matches) || []
  end

  private

  def lost_item_params
    params.require(:lost_item).permit(:title, :description, :category, :location, :date_lost, images: [])
  end

  def authorize_user!
    @lost_item = LostItem.find(params[:id])
    unless @lost_item.user == current_user
      redirect_to lost_items_path, alert: "You are not authorized to do that."
    end
  end

  def find_matches_for(lost_item)
    possible_found_items = FoundItem.where(category: lost_item.category, location: lost_item.location)
    possible_found_items.each do |found_item|
      Match.create(found_item: found_item, lost_item: lost_item)
    end
  end
end
