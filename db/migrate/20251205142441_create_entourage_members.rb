class CreateEntourageMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :entourage_members do |t|
      t.references :entourage, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
