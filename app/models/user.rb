class User < ApplicationRecord
  validates :name, presence: true, on: [:create, :update]
  validates :house_number, presence: true, on: [:create, :update]
  validates :street, presence: true, on: [:create, :update]
  validate :address_is_valid, on: [:create, :update]
  validate :address_is_not_taken, on: [:create]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :reservations, dependent: :destroy

  def address_is_valid
    if house_number.present? && street.present?
      house = house_number.to_i
      if street == 'Almond Cir.' && [1,3,5,7].include?(house)
        return true
      elsif street == 'Almond Ct.' && (2..9).include?(house)
        return true
      elsif street == 'Chestnut Ct.' && (2..10).include?(house)
        return true
      elsif street == 'Eastern Cir.' && [2,4,6,8,10].include?(house)
        return true
      elsif street == 'Eastern Dr.' && [1,2,4,5,6,9,10,11,12,15,16,17].include?(house)
        return true
      elsif street == 'Elm Ct.' && (1..6).include?(house)
        return true
      elsif street == 'Hickory Ct.' && (3..11).include?(house)
        return true
      elsif street == 'Le Parc Ct.' && [1,3,4,5,6,7,8,9,10,11,12,14,15,16,17,18,19,20,21,22,24].include?(house)
        return true
      elsif street == 'Le Parc Dr.' && [4,6,7,8,9,10,11,12,14,15,20,21].include?(house)
        return true
      elsif street == 'Poplar Ct.' && [1,3,4,5,6,7,8,9,10,11,12].include?(house)
        return true
      elsif street == 'Redwood Ct.' && (1..7).include?(house)
        return true
      elsif street == 'Walnut Ct.' && (2..11).include?(house)
        return true
      else
        errors.add(:house_number, " is invalid")
      end
    end
  end

  def address_is_not_taken
    if house_number.present? && street.present?
      house = house_number.to_i
      if User.where('house_number = ?', house).where('street = ?', street).all.count > 0
        errors.add(:base, "Address is already in use. If you think this is a mistake, please contact kunalrkak@gmail.com")
      end
    end
  end
end
