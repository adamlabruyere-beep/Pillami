class DashboardController < ApplicationController
  def index
    today = Date.current
    weekday_name = Date::DAYNAMES[today.wday]

    # Rappels actifs pour aujourd'hui (basé sur days_of_week)
    @todays_reminders = current_user.reminders.includes(:medicament).select do |reminder|
      days = reminder.days_of_week || []
      next false unless days.include?(weekday_name)

      created = reminder.created_at.to_date
      next false if today < created

      weeks = (reminder.repeat_for_weeks || 1).to_i
      weeks = 1 if weeks <= 0
      weeks_diff = (today - created).to_i / 7
      weeks_diff < weeks
    end

    # Médicaments à prendre aujourd'hui
    @todays_medications = @todays_reminders.map(&:medicament).compact.uniq

    # Dernier rappel
    @last_reminder = current_user.reminders.order(time: :desc).first

    # Progression du jour : notifications marquées comme vues (pris)
    @total_reminders_today = @todays_reminders.count
    reminder_ids = @todays_reminders.map(&:id)
    @taken_today = current_user.notifications
                               .where(reminder_id: reminder_ids)
                               .where(scheduled_for: today.beginning_of_day..today.end_of_day)
                               .where(status: true)
                               .count
    @progress_percentage = @total_reminders_today > 0 ? ((@taken_today.to_f / @total_reminders_today) * 100).round : 0

    # Personnes que l'utilisateur suit
    @entourage = current_user.entourage || current_user.create_entourage(name: "Mon entourage")
    @members = @entourage.members
    @following = current_user.member_of_entourages.includes(:user)
  end
end
