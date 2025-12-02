class AddPriseToMedicaments < ActiveRecord::Migration[7.1]
  def change
    add_column :medicaments, :prise, :string, array: true, default: []
  end
end
