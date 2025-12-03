class RemindersController < ApplicationController
  before_action :set_reminder, only: %i[show destroy]

  def index
    @reminders = Reminder.all
  end

  def show
  end

  def new
    @reminder = Reminder.new
    @reminder.days_of_week ||= []
    @pillatheque = current_user.pillatheque
    @medicaments = @pillatheque.medicaments
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.user_id = current_user.id

    if @reminder.save
      redirect_to reminders_path, notice: 'Rappel créé avec succès.'
    else
      @pillatheque = current_user.pillatheque
      @medicaments = @pillatheque.medicaments
      render :new
    end
  end

  def destroy
    @reminder.destroy
    redirect_to reminders_path, notice: 'Rappel supprimé avec succès.'
  end

  private

  def set_reminder
    @reminder = Reminder.find(params[:id])
  end

  def reminder_params
    params.require(:reminder).permit(:medicament_id, :quantity, :mesure, :time, :active, days_of_week: [])
  end
end
