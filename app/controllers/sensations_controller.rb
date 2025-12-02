class SensationsController < ApplicationController
  def show
    @sensation = Sensation.find(params[:id])
  end

  def create
    @sensation = Sensation.new(sensation_params)
    if @sensation.save
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  private

  def sensation_params
    params.require(:sensation).permit(:content, :rating)
  end
end
