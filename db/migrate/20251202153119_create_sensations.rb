class CreateSensations < ActiveRecord::Migration[7.1]
  def change
    create_table :sensations do |t|
      t.text :content
      t.integer :rating
      t.timestamps
    end
  end
end
