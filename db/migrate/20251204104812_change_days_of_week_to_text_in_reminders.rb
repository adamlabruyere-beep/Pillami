class ChangeDaysOfWeekToTextInReminders < ActiveRecord::Migration[7.1]
  def change
  change_column :reminders, :days_of_week, :text
  end
end
