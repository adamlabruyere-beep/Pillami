class SensationsController < ApplicationController
  before_action :set_user

  def index
    @sensations = @user.sensations.order(created_at: :desc)
  end

  def show
    @sensation = @user.sensations.find(params[:id])
  end

  def create
    @sensation = @user.sensations.new(sensation_params)
    if @sensation.save
      redirect_to user_sensations_path(@user), notice: "Votre note a été enregistrée avec succès."
    else
      redirect_to user_sensations_path(@user), alert: "Erreur : le champ ne peut pas être vide."
    end
  end

  def destroy
    @sensation = @user.sensations.find(params[:id])
    @sensation.destroy
    redirect_to user_sensations_path(@user), notice: "La note a été supprimée avec succès."
  end

  private

  def sensation_params
    params.require(:sensation).permit(:content, :rating)
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
