class FoundItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @found_items = FoundItem.all
  end

  def show
    @found_item = FoundItem.find(params[:id])
  end

  def new
    @found_item = FoundItem.new
  end

  def create
    @found_item = FoundItem.new(found_item_params)
    @found_item.user = current_user

    if @found_item.save
      redirect_to @found_item, notice: "Found item reported successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @found_item = FoundItem.find(params[:id])
  end

  def update
    @found_item = FoundItem.find(params[:id])
    if @found_item.update(found_item_params)
      redirect_to @found_item, notice: "Found item updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @found_item = FoundItem.find(params[:id])
    @found_item.destroy
    redirect_to found_items_path, notice: "Found item deleted."
  end

  # ✅ New action to list current user's reports
  def my_reports
    @found_items = current_user.found_items.includes(:matches)
  end

  private

  def found_item_params
    params.require(:found_item).permit(:title, :description, :category, :location, :date_reported, images: [])
  end
end
