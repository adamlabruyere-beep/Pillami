class RemindersController < ApplicationController
  around_action :switch_to_french_locale, only: %i[index new]
  before_action :set_user, except: :by_date
  before_action :authorize_user, only: [:index]
  before_action :set_reminder, only: %i[show destroy]

  def index
    @reminders = @user.reminders
  end

  def show
    redirect_to user_reminders_path(@user)
  end

  def new
    @reminder = @user.reminders.new
    authorize @reminder
    @reminder.days_of_week ||= []
    @pillatheque = @user.pillatheque
    @medicaments = @pillatheque.medicaments
  end

  def create
    @reminder = @user.reminders.new(reminder_params)
    authorize @reminder
    if @reminder.save
      redirect_to user_reminders_path(@user), notice: 'Rappel créé avec succès.'
    else
      @pillatheque = @user.pillatheque
      @medicaments = @pillatheque.medicaments
      render :new
    end
  end

  def destroy
    @reminder.destroy
    redirect_to user_reminders_path(@user), notice: 'Rappel supprimé.'
  end

  def by_date
    date = parse_date(params[:date])
    return render json: { error: "Date invalide" }, status: :bad_request unless date

    reminders = current_user.reminders.includes(:medicament).select do |reminder|
      occurs_on_date?(reminder, date)
    end

    render json: reminders.as_json(
      only: [:id, :time, :quantity, :measure],
      include: { medicament: { only: [:nom] } }
    )
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_reminder
    @reminder = @user.reminders.find(params[:id])
    authorize @reminder
  end

  def authorize_user
    authorize @user, :index?, policy_class: ReminderPolicy
  end

  def reminder_params
    params.require(:reminder).permit(
      :medicament_id,
      :quantity,
      :measure,
      :time,
      :active,
      :repeat_for_weeks,
      days_of_week: []
    )
  end

  def switch_to_french_locale(&)
    I18n.with_locale(:fr, &)
  end

  def parse_date(value)
    return Date.current if value.blank?

    Date.parse(value)
  rescue ArgumentError
    nil
  end

  def occurs_on_date?(reminder, date)
    weekday_name = Date::DAYNAMES[date.wday]
    days = reminder.days_of_week || []
    return false unless days.include?(weekday_name)

    created = reminder.created_at.to_date
    return false if date < created

    weeks = (reminder.repeat_for_weeks || 1).to_i
    weeks = 1 if weeks <= 0

    weeks_diff = (date - created).to_i / 7
    weeks_diff < weeks
  end
end
