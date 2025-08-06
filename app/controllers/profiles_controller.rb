require "open-uri"
class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    @good_deeds_count = @user.found_items.count
    @level = calculate_level(@good_deeds_count)
    @reports_to_next_level = 15 - (@good_deeds_count % 15)
    @thank_you_notes = @user.received_notes.order(created_at: :desc).limit(2)
  end

  def edit
    # Form to edit current user's profile including avatar
  end

  def update
    # Handle predefined Cloudinary avatar selection
    if params[:cloudinary_avatar_url].present?
      attach_cloudinary_avatar(params[:cloudinary_avatar_url])
    end

    if @user.update(profile_params)
      redirect_to profiles_path, notice: 'Profile updated successfully!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def profile_params
    params.require(:user).permit(:first_name, :last_name, :email, :avatar)
  end

  def attach_cloudinary_avatar(cloudinary_url)
    # Validate it's one of our predefined avatars
    return unless AVATAR_OPTIONS.any? { |option| option[:url] == cloudinary_url }

    begin
      # Download and attach the Cloudinary image
      downloaded_image = URI.open(cloudinary_url)
      @user.avatar.attach(
        io: downloaded_image,
        filename: extract_filename_from_url(cloudinary_url),
        content_type: content_type_from_url(cloudinary_url)
      )
    rescue => e
      Rails.logger.error "Failed to attach Cloudinary avatar: #{e.message}"
    end
  end

  def extract_filename_from_url(url)
    # Extract filename from Cloudinary URL
    url.split('/').last.split('_').first + '.jpg'
  end

  def content_type_from_url(url)
    url.include?('.png') ? 'image/png' : 'image/jpeg'
  end

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
