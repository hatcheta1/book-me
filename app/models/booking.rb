# == Schema Information
#
# Table name: bookings
#
#  id          :bigint           not null, primary key
#  accepted    :boolean
#  ended_at    :datetime
#  started_at  :datetime
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

  validates :started_at, :ended_at, presence: true

  validate :time_slot_availability, on: :create

  before_validation :ensure_ended_at_has_value

  def format_time(time)
    time.strftime("%l:%M %P")
  end 

  def format_date(time)
    time.strftime("%B %e, %Y")
  end 

  def time_slot_availability
    business = self.business

    # Ensure we have a business and a valid time range
    if business && started_at && ended_at
      unless validate_booking_time(business, started_at, ended_at)
        errors.add(:base, "The selected time slot is unavailable.")
      end
    end
  end
    
  private
  
  # Validation logic for booking time
  def validate_booking_time(business, proposed_started_at, proposed_ended_at)
    bookings = business.accepted_received_bookings
    
    bookings.none? do |booking|
      (proposed_started_at < booking.ended_at) && (proposed_ended_at > booking.started_at)
    end
  end

  def ensure_ended_at_has_value
    if ended_at.blank?
      self.ended_at = started_at + service.duration.minutes
    end
  end
end
  
