class Reminder < ApplicationRecord
  belongs_to :user
  belongs_to :calendrier
  belongs_to :medicament

  has_many :notifications, dependent: :destroy

  serialize :days_of_week, Array, coder: YAML

  validates :time, presence: { message: "L'heure du rappel est obligatoire" }

  before_validation :set_defaults

  private

  def set_defaults
    self.repeat_for_weeks ||= 1
    self.active = true if active.nil?
  end
end
