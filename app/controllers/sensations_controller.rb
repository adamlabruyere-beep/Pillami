class SensationsController < ApplicationController
  def index
    @sensations = Sensation.order(created_at: :desc)
  end

  def show
    @sensation = Sensation.find(params[:id])
  end

  def create
    @sensation = Sensation.new(sensation_params)
    if @sensation.save
      redirect_to sensations_path, notice: "Votre note a été enregistrée avec succès."
    else
      redirect_to sensations_path, alert: "Erreur : le champ ne peut pas être vide."
    end
  end

  def destroy
    @sensation = Sensation.find(params[:id])
    @sensation.destroy
    redirect_to sensations_path, notice: "La note a été supprimée avec succès."
  end

  private

  def sensation_params
    params.require(:sensation).permit(:content, :rating)
  end
end
