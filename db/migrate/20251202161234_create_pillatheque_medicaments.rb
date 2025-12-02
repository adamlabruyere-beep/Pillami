class CreatePillathequeMedicaments < ActiveRecord::Migration[7.1]
  def change
    create_table :pillatheque_medicaments do |t|
      t.references :pillatheque, null: false, foreign_key: true
      t.references :medicament, null: false, foreign_key: true

      t.timestamps
    end
  end
end
