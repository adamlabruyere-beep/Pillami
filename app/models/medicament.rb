class Medicament < ApplicationRecord
  validates :nom, presence: true

  has_many :pillatheque_medicaments, dependent: :destroy
  has_many :pillatheques, through: :pillatheque_medicaments
end
