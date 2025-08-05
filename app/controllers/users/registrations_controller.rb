require "open-uri"

class Users::RegistrationsController < Devise::RegistrationsController
  # Override Devise's create method
  def create
    super do |resource|
      attach_avatar(resource)
    end
  end

  # Override Devise's update method
  def update
    super do |resource|
      attach_avatar(resource)
    end
  end

  private

  def attach_avatar(resource)
    if params[:avatar_url].present?
      downloaded_image = URI.open(params[:avatar_url])
      resource.avatar.attach(
        io: downloaded_image,
        filename: "avatar.jpg",
        content_type: "image/jpeg"
      )
    end
  end

  def sign_up_params
    params.require(:user).permit(
      :first_name, :last_name, :email,
      :password, :password_confirmation,
      :avatar_url # allow avatar_url to be passed in form
    )
  end

  def account_update_params
    params.require(:user).permit(
      :first_name, :last_name, :email,
      :password, :password_confirmation,
      :current_password,
      :avatar_url # allow avatar_url to be updated
    )
  end

  def update_resource(resource, params)
    if params[:password].present? || params[:password_confirmation].present?
      resource.update_with_password(params)
    else
      raise
      resource.update(params.except(:current_password))
    end
  end
end
