class DropNoticedEvents < ActiveRecord::Migration[7.1]
  def change
    drop_table :noticed_events
  end
end
