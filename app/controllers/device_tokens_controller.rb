class DeviceTokensController < ApplicationController
  before_action :authenticate_user! # ou équivalent

  def create
    token = params[:token]
    return head :bad_request if token.blank?

    device_token = DeviceToken.find_or_initialize_by(token: token)
    device_token.user = current_user
    device_token.platform = params[:platform]
    device_token.last_seen_at = Time.current
    device_token.save!

    head :ok
  end
end
