class DashboardController < ApplicationController
  def index
    # Rappels du jour
    @todays_reminders = current_user.reminders.where(time: Date.today.beginning_of_day..Date.today.end_of_day,
                                                     active: true)

    # Médicaments à prendre aujourd'hui
    @todays_medications = @todays_reminders.includes(:medicament).map(&:medicament).uniq

    # Dernier rappel
    @last_reminder = current_user.reminders.order(time: :desc).first

    # Personnes que l'utilisateur suit
        @entourage = current_user.entourage || current_user.create_entourage(name: "Mon entourage")
    @members = @entourage.members
    @following = current_user.member_of_entourages.includes(:user)
  end
end
