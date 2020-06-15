class User < ApplicationRecord
  validates :name, presence: true, on: :create
  validates :house_number, presence: true, on: :create
  validates :street, presence: true, on: :create
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :reservations, dependent: :destroy
end
