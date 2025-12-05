class CalendriersController < ApplicationController
  around_action :switch_to_french_locale, only: :index

  def index
    today = Date.current

    @current_date = params[:date]&.to_date || Date.today
    @week_start = @current_date.beginning_of_week(:monday)
    @week_days = (@week_start..@week_start + 6).to_a

    @selected_date = if params[:date].present?
                       Date.parse(params[:date])
                     else
                       @week_days.first
                     end

    @initial_index = @week_days.index(today) || 0

    @reminders = current_user.reminders.includes(:medicament)

     @reminders_by_day = @week_days.index_with do |date|
  weekday_name = Date::DAYNAMES[date.wday]

  @reminders.select do |r|
    days = r.days_of_week || []
    next false unless days.include?(weekday_name)

    start_date = [r.created_at.to_date, Date.current].max

    # nombre de semaines de répétition (min 1)
    weeks = (r.repeat_for_weeks || 1).to_i
    weeks = 1 if weeks <= 0
    end_date   = start_date + (weeks - 1).weeks

    created = r.created_at.to_date

    # si la date du calendrier est avant la création du rappel → on ignore
    days_diff = (date - created).to_i
    next false if days_diff < 0

    # nombre de semaines écoulées entre la création et la date du calendrier
    weeks_diff = days_diff / 7

    # on affiche le rappel seulement si on est encore dans la fenêtre de répétition
    weeks_diff < weeks

    (start_date..end_date).cover?(date)
  end
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
