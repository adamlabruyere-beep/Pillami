class MedicamentsController < ApplicationController
  def index
    @pillatheque = current_user.pillatheque
    if params[:query].present?
      @medicaments = Medicament.where("nom ILIKE ?", "%#{params[:query]}%")
    elsif params[:query] == ""
      @empty_query = true
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
