class CreateReminders < ActiveRecord::Migration[7.1]
  def change
    create_table :reminders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :medicament, null: false, foreign_key: true
      t.string :message
      t.string :days_of_week
      t.time :time
      t.boolean :active
      t.timestamps
    end
  end
end
