class ChangeDefaultForNotificationsRead < ActiveRecord::Migration[7.1]
  def change
    change_column_default :notifications, :read, false
    Notification.where(read: nil).update_all(read: false)
  end
end
