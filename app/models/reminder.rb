class Reminder < ApplicationRecord
  belongs_to :user
  belongs_to :calendrier
  belongs_to :medicament

  has_many :notifications, dependent: :destroy

  # Sérialisation des jours de la semaine pour stocker un array YAML
  serialize :days_of_week, Array, coder: YAML

  validates :time, presence: { message: "L'heure du rappel est obligatoire" }

  before_validation :set_default_repeat_weeks

  private

  def set_default_repeat_weeks
    self.repeat_for_weeks ||= 1
  end

  private

  # Planifie le job de notification à la prochaine occurrence
  # def next_reminder_time
  #   return unless active && days_of_week.present? && time.present?

  #   today_name = Date.today.strftime("%A") # "Monday", "Tuesday", etc.

  #   # Vérifie si le jour d'aujourd'hui est dans les jours actifs du reminder
  #   return next_occurrence_after_today unless days_of_week.include?(today_name)

  #   # Récupère l'heure du reminder
  #   now = Time.current
  #   reminder_time_today = now.change({ hour: time.hour, min: time.min, sec: 0 })

  #   # Si l'heure est déjà passée, planifie pour le prochain jour actif
  #   return reminder_time_today > now ? reminder_time_today : next_occurrence_after_today

  #   # Si aujourd'hui n'est pas actif, planifie pour le prochain jour actif
  # end

  def schedule_next_occurrence













    # today_wday_index = Date.today.wday # 0 = Sunday
    # weekdays_index_map = {
    #   "Sunday" => 0, "Monday" => 1, "Tuesday" => 2, "Wednesday" => 3,
    #   "Thursday" => 4, "Friday" => 5, "Saturday" => 6
    # }

    # # Convertir days_of_week en indices
    # active_days_indices = days_of_week.map { |d| weekdays_index_map[d] }

    # # Trouver le prochain jour actif après aujourd'hui
    # next_day_index = active_days_indices.select { |i| i > today_wday_index }.min || active_days_indices.min
    # days_until_next = (next_day_index - today_wday_index) % 7

    # next_date = Date.today + days_until_next
    # next_date.to_datetime.change({ hour: time.hour, min: time.min, sec: 0 })
  end
end
