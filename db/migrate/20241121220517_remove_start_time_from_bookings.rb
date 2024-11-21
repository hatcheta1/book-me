class RemoveStartTimeFromBookings < ActiveRecord::Migration[7.1]
  def change
    remove_column :bookings, :start_time, :time
  end
end
