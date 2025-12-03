class CalendriersController < ApplicationController
  around_action :switch_to_french_locale, only: :index

  def index
    @start_date = params.fetch(:start_date, Date.today).to_date
    week_start  = @start_date.beginning_of_week(:monday)

    @week_days = 0.upto(6).map { |offset| week_start + offset.days }
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
