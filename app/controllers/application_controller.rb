class ApplicationController < ActionController::Base
  before_action do
   I18n.locale = :fr
  end
  before_action :authenticate_user!
  before_action :ensure_pillatheque, if: :user_signed_in?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:prenom, :nom])
    devise_parameter_sanitizer.permit(:account_update, keys: [:prenom, :nom])
  end

  private

  def ensure_pillatheque
    current_user.create_pillatheque unless current_user.pillatheque
  end
end
