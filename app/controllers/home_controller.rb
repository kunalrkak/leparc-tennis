class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:guidelines, :notice]

  def index
    if user_signed_in?
      # TODO: REMOVE NOTICE
      # redirect_to reservations_url
      redirect_to home_notice_url
    else 
      redirect_to new_user_session_url
    end
  end

  def guidelines
  end

  def notice
  end
end
