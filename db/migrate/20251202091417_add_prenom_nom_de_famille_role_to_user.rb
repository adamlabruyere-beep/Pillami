class AddPrenomNomDeFamilleRoleToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :prenom, :string
    add_column :users, :nom_de_famille, :string
    add_column :users, :role, :string
  end
end
