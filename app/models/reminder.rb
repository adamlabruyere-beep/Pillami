class Reminder < ApplicationRecord
  belongs_to :user
  belongs_to :medicament
  belongs_to :calendrier
  serialize :days_of_week, type: Array, coder: YAML
  validates :time, presence: { message: "L'heure du rappel est obligatoire" }
end
