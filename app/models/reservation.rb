class Reservation < ApplicationRecord
  validates :start, presence: true, on: :create

  belongs_to :user
end
