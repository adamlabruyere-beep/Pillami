class EntouragesController < ApplicationController
  before_action :authenticate_user!

  def show
    @entourage = current_user.entourage || current_user.create_entourage(name: "Mon entourage")
    @members = @entourage.members
  end

  def create
    @entourage = current_user.build_entourage(entourage_params)
    if @entourage.save
      redirect_to entourage_path, notice: "Entourage créé avec succès"
    else
      redirect_to entourage_path, alert: "Erreur lors de la création"
    end
  end

  def destroy
    @entourage = current_user.entourage
    @entourage.destroy
    redirect_to entourage_path, notice: "Entourage supprimé"
  end

  private

  def entourage_params
    params.require(:entourage).permit(:name)
  end
end
