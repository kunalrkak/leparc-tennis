require 'sidekiq/web'

Rails.application.routes.draw do
  # TODO: REMOVE NOTICE
  # get 'reservations/me', to: 'reservations#me'
  # resources :reservations, only: [:index, :show, :create, :destroy]
  #   authenticate :user, lambda { |u| u.admin? } do
  #     mount Sidekiq::Web => '/sidekiq'
  #   end

  devise_for :users, :controllers => { registrations: 'users/registrations' }
  # get 'users/all', to: 'users#all'
  # get 'home/guidelines', to: 'home#guidelines'
  get 'home/notice', to: 'home#notice'
  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
