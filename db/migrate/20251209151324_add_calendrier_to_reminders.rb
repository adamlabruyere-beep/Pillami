class AddCalendrierToReminders < ActiveRecord::Migration[7.1]
  def change
    add_reference :reminders, :calendrier, foreign_key: true
  end
end
