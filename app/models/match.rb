class Match < ApplicationRecord
  belongs_to :lost_item
  belongs_to :found_item
  attribute :confirmed, :boolean, default: false
  after_update :send_thank_you_if_confirmed

  validate :users_cannot_be_same
  def users_cannot_be_same
    if lost_item && found_item && lost_item.user_id == found_item.user_id
      errors.add(:base, "User cannot match their own lost and found items.")
    end
  end


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
