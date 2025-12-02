class CalendriersController < ApplicationController
  def index
    start_date = params.fetch(:start_date, Date.today).to_date
  end

  def by_day
    @date  = params[:date]&.to_date || Date.today

    @entries = Calendrier.where(date: @date).order(:created_at)

    render partial: "panneau du jour",
           locals: { date: @date, entries: @entries }
  end
end
