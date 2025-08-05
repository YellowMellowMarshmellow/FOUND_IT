class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_notifications, if: :user_signed_in?

  def openai_description_match?(found_desc, lost_desc)
    return false if found_desc.blank? || lost_desc.blank?

    prompt = <<~TEXT
      Do these two descriptions likely refer to the same physical object? Answer only "yes" or "no".

      Lost item description:
      #{lost_desc}

      Found item description:
      #{found_desc}
    TEXT

    response = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"]).chat(
      parameters: {
        model: "gpt-4o-mini", # or "gpt-4", "gpt-3.5-turbo", etc.
        messages: [
          { role: "system", content: "Only respond with yes or no." },
          { role: "user", content: prompt }
        ],
        temperature: 0.0
      }
    )

    answer = response.dig("choices", 0, "message", "content").to_s.strip.downcase
    Rails.logger.info("OpenAI answer: #{answer}")  # add this line to log answer
    puts "OpenAI answer: #{answer}"                # also print in console during test

    answer == "yes"
    rescue => e
      Rails.logger.error("OpenAI error: #{e.message}")
      false
  end

  protected

  def after_sign_in_path_for(resource)
    root_path
  end

  def configure_permitted_parameters
    added_attrs = [:first_name, :last_name, :email, :password, :password_confirmation, :avatar_url]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  private

  def set_notifications
    @notifications = current_user.notifications.order(created_at: :desc)
    @unread_notifications_count = @notifications.where(read: false).count
  end
end
