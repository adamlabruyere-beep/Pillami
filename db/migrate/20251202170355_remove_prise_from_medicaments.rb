class RemovePriseFromMedicaments < ActiveRecord::Migration[7.1]
  def change
    remove_column :medicaments, :prise, :string
  end
end
