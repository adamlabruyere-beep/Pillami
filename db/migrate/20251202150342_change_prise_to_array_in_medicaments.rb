class ChangePriseToArrayInMedicaments < ActiveRecord::Migration[7.1]
  def up
    return unless table_exists?(:medicaments)

    column = columns(:medicaments).find { |col| col.name == "prise" }
    return if column.nil? || column.array

    change_column :medicaments, :prise, :string, array: true, default: []
  end

  def down
    return unless table_exists?(:medicaments)

    column = columns(:medicaments).find { |col| col.name == "prise" }
    return if column.nil? || !column.array

    change_column :medicaments, :prise, :string, default: nil
  end
end
