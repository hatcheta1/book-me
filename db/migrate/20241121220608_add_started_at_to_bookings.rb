class AddStartedAtToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :started_at, :datetime
  end
end
