class AddRepeatForWeeksToReminders < ActiveRecord::Migration[7.1]
  def change
    add_column :reminders, :repeat_for_weeks, :integer
  end
end
