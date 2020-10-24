class Reservation < ApplicationRecord
  validates :start, presence: true, on: :create
  validates :date, presence: true, on: :create

  belongs_to :user
end
