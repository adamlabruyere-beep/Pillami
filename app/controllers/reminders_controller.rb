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
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.message = "#{params[:reminder][:quantity]} #{params[:reminder][:measure]}"
    if @reminder.save
      redirect_to @reminder, notice: 'Rappel créé avec succès.'
    else
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
    params.require(:reminder).permit(:user_id, :message, :days_of_week, :time, :active)
  end
end
