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
end
