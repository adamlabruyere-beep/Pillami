class DropNoticedNotifications < ActiveRecord::Migration[7.1]
  def change
   drop_table :noticed_notifications
  end
end
