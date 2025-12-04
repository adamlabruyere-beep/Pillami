class AddUserToSensations < ActiveRecord::Migration[7.1]
  def change
    add_reference :sensations, :user, null: false, foreign_key: true
  end
end
