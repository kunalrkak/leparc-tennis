class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :is_admin?

    def all
        @users = User.order(:id).all
    end

    def is_admin?
        redirect_to root_path unless User.find(current_user.id).admin 
    end
  end
  