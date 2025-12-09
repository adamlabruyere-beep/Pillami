class NotificationsController < ApplicationController
  before_action :set_user

  def index
    @notifications = @user.notifications.order(created_at: :desc)
  end

  def update
    @notification = @user.notifications.find(params[:id])
    @notification.update!(status: true)

    respond_to do |format|
      format.html { redirect_back fallback_location: user_notifications_path(@user) }
      format.turbo_stream
    end
  end

  def bell
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_user
    @user = current_user
  end
end
