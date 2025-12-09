class AddMessageToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :message, :text
  end
end
