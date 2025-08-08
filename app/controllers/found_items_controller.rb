class FoundItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_found_item, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @found_items = FoundItem.all
    # The `geocoded` scope filters only flats with coordinates
    @markers = @found_items.geocoded.map do |found_item|
      {
        lat: found_item.latitude,
        lng: found_item.longitude
      }
    end
  end

  def show
  end

  def new
    @found_item = FoundItem.new
  end

  def create
    @found_item = current_user.found_items.build(found_item_params)
    @found_item.user = current_user

    if @found_item.save
      LostItem.where(category: @found_item.category)
              .near([@found_item.latitude, @found_item.longitude], 5, units: :mi)
              .find_each do |lost_item|

        next if lost_item.user_id == @found_item.user_id  # 💥 Prevent self-matching

        if openai_description_match?(@found_item.description, lost_item.description)
          match = Match.new(lost_item: lost_item, found_item: @found_item)

          if match.save
            Notification.create!(
              user: lost_item.user,
              message: "A potential match has been found for your lost object: #{lost_item.title}. Please confirm.",
              notifiable: match
            )
          end
        end
      end
      redirect_to root_path, notice: "Found item reported successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @found_item = FoundItem.find(params[:id])

    if @found_item.matches.any? { |match| match.confirmed? }
      redirect_to found_item_path(@found_item), alert: "You cannot edit this item because a match has already been confirmed."
    end
  end

  def update

    if params[:found_item][:remove_image_ids]
      params[:found_item][:remove_image_ids].each do |id|
        image = @found_item.images.find(id)
        image.purge
      end
    end

    if @found_item.update(found_item_params)
      redirect_to root_path, notice: "Found item updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @found_item.destroy
    redirect_to found_items_path, notice: "Found item deleted."
  end

  def my_reports
    @found_items = current_user.found_items.includes(:matches)
  end

  def delete_image
    @found_item = FoundItem.find(params[:id])
    image = @found_item.images.find(params[:image_id])
    image.purge
    respond_to do |format|
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(
        "image-upload-section",
        partial: "found_items/image_upload_section",
        locals: { found_item: @found_item }
      )
      end
      format.html { redirect_to edit_found_item_path(@found_item), notice: "Image deleted." }
    end
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
