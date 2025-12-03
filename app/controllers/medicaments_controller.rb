class MedicamentsController < ApplicationController
  def index
    if params[:query]
      @medicaments = Medicament.all.where("nom ILIKE ?", "%#{params[:query]}%") if params[:query].present?
      @pillatheque = current_user.pillatheque
    else
      @medicaments = []
    end
  end

  def create
    @medicament = Medicament.new(medicament_params)
    if @medicament.save
      redirect_to pillatheque_path(current_user.pillatheque), notice: "Médicament créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def medicament_params
    params.require(:medicament).permit(:nom, :format, :ordonnance, prise: [])
  end
end
