class CalendriersController < ApplicationController
  around_action :switch_to_french_locale, only: :show
  before_action :set_user
  before_action :authorize_user

  def show
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

    @reminders = @user.reminders.includes(:medicament)

    @reminders_by_day = @week_days.index_with do |date|
      weekday_name = Date::DAYNAMES[date.wday]

      @reminders.select do |r|
        days = r.days_of_week || []
        next false unless days.include?(weekday_name)

        created = r.created_at.to_date
        next false if date < created

        weeks = (r.repeat_for_weeks || 1).to_i
        weeks = 1 if weeks <= 0

        weeks_diff = (date - created).to_i / 7
        weeks_diff < weeks
      end
    end
    # Toutes les sensations de l'utilisateur (on n'a besoin que de la date)
    @sensations = current_user.sensations

  # Hash : date -> sensations de ce jour
    @sensations_by_day = @week_days.index_with do |date|
      @sensations.select { |s| s.created_at.to_date == date }
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def authorize_user
    authorize @user, :show?, policy_class: CalendrierPolicy
  end

  def switch_to_french_locale
    I18n.with_locale(:fr) { yield }
  end
end
