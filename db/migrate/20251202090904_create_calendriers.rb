class CreateCalendriers < ActiveRecord::Migration[7.1]
  def change
    create_table :calendriers do |t|

      t.timestamps
    end
  end
end
