class Reminder < ApplicationRecord
  belongs_to :user
  belongs_to :calendrier
  belongs_to :medicament, optional: true

  has_many :notifications, dependent: :destroy

  serialize :days_of_week, Array, coder: YAML

  validates :time, presence: { message: "L'heure du rappel est obligatoire" }
  validates :medicament_id, presence: { message: "Veuillez sélectionner un médicament" }
  validate :days_of_week_not_empty

  before_validation :set_defaults

  private

  def days_of_week_not_empty
    if days_of_week.blank? || days_of_week.reject(&:blank?).empty?
      errors.add(:base, "Veuillez sélectionner au moins un jour")
    end
  end

  def set_defaults
    self.repeat_for_weeks ||= 1
    self.active = true if active.nil?
  end
end
