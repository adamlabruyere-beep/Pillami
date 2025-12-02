class MedicamentsController < ApplicationController
  def index
    @medicaments = Medicament.all
    @medicaments = @medicaments.where("nom ILIKE ?", "%#{params[:query]}%") if params[:query].present?
    @pillatheque = current_user.pillatheque
  end

  def new
    @medicament = Medicament.new
  end

  def create
    @medicament = Medicament.new(medicament_params)
    if @medicament.save
      redirect_to root_path, notice: "Médicament créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def medicament_params
    params.require(:medicament).permit(:nom, :format, :ordonnance, prise: [])
  end
end
