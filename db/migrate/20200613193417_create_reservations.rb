class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.time :start
      t.time :end
      t.date :date

      t.timestamps
    end
  end
end
