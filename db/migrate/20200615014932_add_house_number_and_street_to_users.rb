class AddHouseNumberAndStreetToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :house_number, :integer
    add_column :users, :street, :string
  end
end
