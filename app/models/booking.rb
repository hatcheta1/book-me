# == Schema Information
#
# Table name: bookings
#
#  id          :bigint           not null, primary key
#  accepted    :boolean
#  date        :date
#  end_time    :time
#  start_time  :time
#  time_zone   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  business_id :bigint           not null
#  client_id   :bigint           not null
#  service_id  :bigint           not null
#
# Indexes
#
#  index_bookings_on_business_id  (business_id)
#  index_bookings_on_client_id    (client_id)
#  index_bookings_on_service_id   (service_id)
#
# Foreign Keys
#
#  fk_rails_...  (business_id => businesses.id)
#  fk_rails_...  (client_id => users.id)
#  fk_rails_...  (service_id => services.id)
#
class Booking < ApplicationRecord
  belongs_to :client, class_name: "User"

  belongs_to :business
  
  belongs_to :service

  has_many :received_bookings, class_name: "Booking"
  
  has_many :accepted_received_bookings, -> { accepted }, class_name: "Booking"
end
