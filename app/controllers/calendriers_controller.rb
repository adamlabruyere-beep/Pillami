class CalendriersController < ApplicationController
  around_action :switch_to_french_locale, only: :index

  def index
    @current_date = params[:date]&.to_date || Date.today
    @week_start = @current_date.beginning_of_week(:monday)
    @week_days = (@week_start..@week_start + 6).to_a

    @selected_date = if params[:date].present?
                       Date.parse(params[:date])
                     else
                       @week_days.first
                     end

    @reminders = current_user.reminders.includes(:medicament)

    @reminders_by_day = @week_days.index_with do |date|
      english_day_name = Date::DAYNAMES[date.wday]
      @reminders.select { |r| (r.days_of_week || []).include?(english_day_name) }
    end
  end

  def create
    @calendrier = current_user.calendriers.new(calendrier_params)

    if @calendrier.save
      redirect_to @calendrier
    else
      render :new
    end
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
