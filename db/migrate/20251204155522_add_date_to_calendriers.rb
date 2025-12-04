class AddDateToCalendriers < ActiveRecord::Migration[7.1]
  def change
    add_column :calendriers, :date, :date
  end
end
