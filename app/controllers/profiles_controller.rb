# app/controllers/profiles_controller.rb
class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @good_deeds_count = @user.found_items.count
    @level = calculate_level(@good_deeds_count)
    @reports_to_next_level = 15 - @good_deeds_count % 15
    @thank_you_notes = @user.received_notes.order(created_at: :desc).limit(2)
  end

  private

  def calculate_level(count)
    case count
    when 0..4
      "Helper in Training"
    when 5..14
      "Kindness Ambassador"
    else
      "Guardian of Good"
    end
  end
end
