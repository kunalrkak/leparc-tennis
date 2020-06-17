class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :is_admin?

    def all
        @users = User.order(:id).all
    end

    def is_admin?
        raise ActionController::RoutingError.new('Not Found') unless User.find(current_user.id).admin 
    end
  end
  