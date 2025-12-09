class RemindersController < ApplicationController
  around_action :switch_to_french_locale, only: %i[index new]
  before_action :set_user
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
    date = Date.parse(params[:date])
    weekday_name = Date::DAYNAMES[date.wday]

    reminders = current_user.reminders.select do |r|
      days = r.days_of_week || []
      next false unless days.include?(weekday_name)

      weeks = (r.repeat_for_weeks || 1).to_i
      weeks = 1 if weeks <= 0

      created = r.created_at.to_date
      days_diff = (date - created).to_i
      next false if days_diff < 0

      weeks_diff = days_diff / 7
      weeks_diff < weeks
    end

    render json: reminders.as_json(
      only: %i[id time quantity measure],
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
end
