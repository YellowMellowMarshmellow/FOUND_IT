class LostItemsController < ApplicationController
  before_action :authenticate_user!

  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @lost_items = LostItem.all
  end

  def show
    @lost_item = LostItem.find(params[:id])
  end

  def new
    @lost_item = LostItem.new
  end

  def create
    @lost_item = LostItem.new(lost_item_params)
    @lost_item.user = current_user

    if @lost_item.save

      redirect_to root_path, notice: "Lost item reported successfully."

    else
      render :new, status: :unprocessable_entity
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
end
