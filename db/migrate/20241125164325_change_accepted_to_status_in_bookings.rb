class ChangeAcceptedToStatusInBookings < ActiveRecord::Migration[7.1]
  def change
    remove_column :bookings, :accepted, :boolean
    add_column :bookings, :status, :integer, default: 0, null: false
  end
end
