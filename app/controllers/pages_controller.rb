class PagesController < ApplicationController
  def home
    #just checking heroku
  end

  def create_report
    if params[:found_item].present?
      @found_item = FoundItem.new(found_item_params)
      @found_item.user = current_user

      if @found_item.save
        LostItem.where(category: @found_item.category, location: @found_item.location).find_each do |lost_item|
          Match.create!(lost_item: lost_item, found_item: @found_item)
          Notification.create!(
            user: lost_item.user,
            message: "A potential match has been found for your lost object: #{lost_item.title}. Please confirm.",
            notifiable: lost_item
          )
        end
        redirect_to root_path, notice: "Found item reported successfully."
      else
        @lost_item = LostItem.new # needed so lost form doesn't break
        render :create_report, status: :unprocessable_entity
      end

    elsif params[:lost_item].present?
      @lost_item = LostItem.new(lost_item_params)
      @lost_item.user = current_user

      if @lost_item.save
        FoundItem.where(category: @lost_item.category, location: @lost_item.location).find_each do |found_item|
          Match.create!(lost_item: @lost_item, found_item: found_item)

          Notification.create!(
            user: @lost_item.user,
            message: "A found item matches your lost item: #{found_item.title}"
          )

          Notification.create!(
            user: found_item.user,
            message: "A lost item matches your found item: #{@lost_item.title}"
          )
        end
        redirect_to root_path, notice: "Lost item reported successfully."
      else
        @found_item = FoundItem.new # needed so found form doesn't break
        render :create_report, status: :unprocessable_entity
      end
    else
      # If neither form is submitted
      @found_item = FoundItem.new
      @lost_item = LostItem.new
      render :create_report
    end
  end

  private

  def found_item_params
    params.require(:found_item).permit(:title, :description, :location, :date_reported, :category, images: [])
  end

  def lost_item_params
    params.require(:lost_item).permit(:title, :description, :location, :date_lost, :category)
  end
end
