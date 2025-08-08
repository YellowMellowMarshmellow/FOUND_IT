class LostItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  before_action :set_lost_item, only: [:show, :edit, :update, :destroy]

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
    @lost_item = current_user.lost_items.build(lost_item_params)
    @lost_item.user = current_user

    if @lost_item.save
      FoundItem.where(category: @lost_item.category)
              .near([@lost_item.latitude, @lost_item.longitude], 5, units: :mi)
              .find_each do |found_item|

        next if found_item.user_id == @lost_item.user_id  # 💥 Prevent self-matching

        if openai_description_match?(found_item.description, @lost_item.description)
          match = Match.new(lost_item: @lost_item, found_item: found_item)

          if match.save
            Notification.create!(
              user: @lost_item.user,
              message: "A found item matched your lost item: #{found_item.title}",
              notifiable: match
            )
          end
        end
      end
      redirect_to root_path, notice: "Lost item reported successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @lost_item = LostItem.find(params[:id])
  end

  def update
    if @lost_item.update(lost_item_params)
      redirect_to root_path, notice: "Lost item updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @lost_item.destroy
    redirect_to root_path, notice: "Lost item deleted."
  end

  def my_reports
    @my_lost_items = current_user.lost_items.includes(:matches) || []
  end

  def delete_image
    @lost_item = LostItem.find(params[:id])
    image = @lost_item.images.find(params[:image_id])
    image.purge
    redirect_to edit_lost_item_path(params[:id]), notice: "Image deleted."
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

  def set_lost_item
    @lost_item = LostItem.find(params[:id])
  end

end
