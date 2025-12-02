class PillathequesController < ApplicationController
  def show
    @pillatheque = current_user.pillatheque 
    @medicaments = @pillatheque.medicaments
  end
end
