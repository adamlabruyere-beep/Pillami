class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  def home
    @user = current_user
    redirect_to dashboard_path if user_signed_in?
  end
end
