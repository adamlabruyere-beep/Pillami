class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]
# rgrgr
  def home
  end
end
