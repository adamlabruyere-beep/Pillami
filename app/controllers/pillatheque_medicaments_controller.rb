class PillathequeMedicamentsController < ApplicationController
  def create
    @pillatheque = current_user.pillatheque
    @medicament = Medicament.find(params[:medicament_id])

    if @pillatheque.medicaments.include?(@medicament)
      redirect_to pillatheque_path(@pillatheque), alert: "Ce médicament est déjà dans votre pillathèque."
    else
      @pillatheque.medicaments << @medicament
      redirect_to pillatheque_path(@pillatheque), notice: "#{@medicament.nom} ajouté à votre pillathèque."
    end
  end

  def destroy
    @pillatheque = current_user.pillatheque
    @pillatheque_medicament = @pillatheque.pillatheque_medicaments.find(params[:id])
    @pillatheque_medicament.destroy
    redirect_to pillatheque_path(current_user), notice: "Médicament retiré de votre pillathèque."
  end
end
