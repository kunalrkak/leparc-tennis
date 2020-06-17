require 'sidekiq/web'

Rails.application.routes.draw do
  get 'reservations/me', to: 'reservations#me'
  resources :reservations, only: [:index, :show, :create, :destroy]
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end

  devise_for :users, :controllers => { registrations: 'users/registrations' }
  get 'users/all', to: 'users#all'
  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
