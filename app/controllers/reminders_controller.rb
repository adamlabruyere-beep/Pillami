class RemindersController < ApplicationController
  before_action :set_user
  before_action :set_reminder, only: %i[show destroy]

  def index
    @reminders = @user.reminders
  end

  def show
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
