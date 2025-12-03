class AddQuantityAndMeasureToReminders < ActiveRecord::Migration[7.1]
  def change
    add_column :reminders, :quantity, :integer
    add_column :reminders, :measure, :string
  end
end
