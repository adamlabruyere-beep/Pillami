class AddLinksToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_reference :notifications, :user, null: false, foreign_key: true
    add_reference :notifications, :reminder, null: false, foreign_key: true
    add_column :notifications, :scheduled_for, :datetime
    change_column_default :notifications, :status, from: nil, to: false
  end
end
