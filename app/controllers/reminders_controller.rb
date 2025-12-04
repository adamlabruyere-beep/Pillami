class RemindersController < ApplicationController
  before_action :set_user
  before_action :set_reminder, only: %i[show destroy]

  def index
    @reminders = @user.reminders
  end

  def show
    redirect_to user_reminders_path(@user)
  end

  def new
    @reminder = @user.reminders.new
    @reminder.days_of_week ||= []
    @pillatheque = @user.pillatheque
    @medicaments = @pillatheque.medicaments
  end

  def create
    @reminder = @user.reminders.new(reminder_params)

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

    weekday_name = date.strftime("%A")

    reminders = current_user.reminders.select do |r|
      r.days_of_week.include?(weekday_name)
    end

    render json: reminders.as_json(only: [:id, :time, :quantity, :measure], include: {
      medicament: { only: [:nom] }
    })
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_reminder
    @reminder = @user.reminders.find(params[:id])
  end

  def reminder_params
    params.require(:reminder).permit(:medicament_id, :quantity, :measure, :time, :active, days_of_week: [])
  end
end
