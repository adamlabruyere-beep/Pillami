class PillathequesController < ApplicationController
  def show
    @pillatheque = current_user.pillatheque
    authorize @pillatheque
    @medicaments = @pillatheque.medicaments
  end
end
