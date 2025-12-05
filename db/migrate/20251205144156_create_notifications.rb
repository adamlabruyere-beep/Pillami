class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.time :time
      t.boolean :status

      t.timestamps
    end
  end
end
