class Match < ApplicationRecord
  belongs_to :lost_item
  belongs_to :found_item

  attribute :confirmed, :boolean, default: false

  after_update :send_thank_you_if_confirmed

  private

  def send_thank_you_if_confirmed
    return unless saved_change_to_confirmed? && confirmed?
    return if lost_item.user_id == found_item.user_id

    Notification.create!(
      user: found_item.user,
      message: "Someone recovered their lost item thanks to your report."
    )
  end
end
