class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to reservations_url
    else 
      redirect_to new_user_session_url
    end
  end
end