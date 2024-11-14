class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :client, null: false, foreign_key: { to_table: :users }
      t.references :business, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.time :start_time
      t.time :end_time
      t.date :date
      t.string :time_zone
      t.boolean :accepted

      t.timestamps
    end
  end
end
