class Reminder < ApplicationRecord
  belongs_to :user
  belongs_to :medicament

  serialize :days_of_week, Array, coder: YAML

  validates :time, presence: { message: "L'heure du rappel est obligatoire" }

  before_validation :set_default_repeat_weeks

  private

  def set_default_repeat_weeks
    self.repeat_for_weeks ||= 1
  end
end
