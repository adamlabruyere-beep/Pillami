class CalendriersController < ApplicationController
  around_action :switch_to_french_locale, only: :index

  def index
    # On part de la date donnée ou d'aujourd'hui
    @current_date = params[:date]&.to_date || Date.today

    # On calcule le début de la semaine (lundi → style européen)
    @week_start = @current_date.beginning_of_week(:monday)

    # Les 7 jours de la semaine
    @week_days = (@week_start..@week_start + 6).to_a
  end

  def by_day
    @date  = params[:date]&.to_date || Date.today

    @entries = Calendrier.where(date: @date).order(:created_at)

    render partial: "panneau du jour",
           locals: { date: @date, entries: @entries }
  end

  private

  def switch_to_french_locale
    I18n.with_locale(:fr) { yield }
  end
end
