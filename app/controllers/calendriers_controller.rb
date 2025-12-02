class CalendriersController < ApplicationController
  def index
    start_date = params.fetch(:start_date, Date.today).to_date
  end
end
