class RemoveTimeZoneFromBookings < ActiveRecord::Migration[7.1]
  def change
    remove_column :bookings, :time_zone, :string
  end
end
