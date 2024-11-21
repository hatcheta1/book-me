class AddEndedAtToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :ended_at, :datetime
  end
end
