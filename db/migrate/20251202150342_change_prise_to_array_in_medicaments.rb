class ChangePriseToArrayInMedicaments < ActiveRecord::Migration[7.1]
  def change
    remove_column :medicaments, :prise, :string
    add_column :medicaments, :prise, :string, array: true, default: []
  end
end
