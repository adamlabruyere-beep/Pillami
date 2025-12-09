class DashboardController < ApplicationController
  before_action :authenticate_user! # bloque l'accès aux non-connectés

  def index
    # logique du dashboard ici
  end
end
