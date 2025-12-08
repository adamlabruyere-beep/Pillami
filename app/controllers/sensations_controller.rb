class SensationsController < ApplicationController
  before_action :set_user
  before_action :authorize_user, only: [:index]
  before_action :set_sensation, only: [:show, :destroy]

  def index
    @sensations = @user.sensations.order(created_at: :desc)
  end

  def show
  end

  def create
    @sensation = @user.sensations.new(sensation_params)
    authorize @sensation
    if @sensation.save
      redirect_to user_sensations_path(@user), notice: "Votre note a été enregistrée avec succès."
    else
      redirect_to user_sensations_path(@user), alert: "Erreur : le champ ne peut pas être vide."
    end
  end

  def destroy
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

  def set_sensation
    @sensation = @user.sensations.find(params[:id])
    authorize @sensation
  end

  def authorize_user
    authorize @user, :index?, policy_class: SensationPolicy
  end
end
