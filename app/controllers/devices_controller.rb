class DevicesController < ApplicationController
  before_action :authenticate_user!

  def create
    device = Device.find_or_initialize_by(token: params[:token])
    device.user = current_user
    device.platform = params[:platform]
    device.save!

    head :ok
  end
end
