class Match < ApplicationRecord
  belongs_to :lost_item
  belongs_to :found_item
  attribute :confirmed, :boolean, default: false
  after_update :send_thank_you_if_confirmed
  after_destroy :destroy_notifications
  has_many :notifications, as: :notifiable, dependent: :destroy

  validate :users_must_be_different

  def destroy_notifications
    Notification.where(notifiable: self).destroy_all
  end

  def users_must_be_different
  if lost_item.user_id == found_item.user_id
    errors.add(:base, "You cannot match your own lost and found items.")
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
