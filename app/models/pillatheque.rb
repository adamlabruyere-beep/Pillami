class Pillatheque < ApplicationRecord
  belongs_to :user
  has_many :pillatheque_medicaments, dependent: :destroy
  has_many :medicaments, through: :pillatheque_medicaments
end
