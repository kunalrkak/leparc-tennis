class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:guidelines]

  def index
    if user_signed_in?
      redirect_to reservations_url
    else 
      redirect_to new_user_session_url
    end
  end

  def guidelines
  end
end
