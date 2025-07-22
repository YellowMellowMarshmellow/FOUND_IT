class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true, optional: true
  scope :unread, -> { where(read: false) }

  after_initialize :set_default_read, if: :new_record?

  private

  def set_default_read
    self.read = false if read.nil?
  end
end
