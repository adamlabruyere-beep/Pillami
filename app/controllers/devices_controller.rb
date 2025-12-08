class DevicesController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.devices.find_or_create_by!(
      token: params[:token],
      platform: params[:platform]
    )
    head :ok
  end
end
