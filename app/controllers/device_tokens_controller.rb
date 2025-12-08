class DeviceTokensController < ApplicationController
  before_action :authenticate_user! # ou équivalent

  def create
    token = params[:token]
    return head :bad_request if token.blank?

    current_user.device_tokens
                .find_or_initialize_by(token: token)
                .update!(platform: params[:platform], last_seen_at: Time.current)

    head :ok
  end
end
