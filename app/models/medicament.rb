class Medicament < ApplicationRecord
  validates :nom, presence: true
end
