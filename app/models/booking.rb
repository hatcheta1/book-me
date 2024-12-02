# == Schema Information
#
# Table name: bookings
#
#  id          :bigint           not null, primary key
#  ended_at    :datetime
#  started_at  :datetime
#  status      :integer          default("pending"), not null
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

  before_validation :ensure_ended_at_has_value, on: :create
  before_validation :convert_times_to_business_timezone

  validate :time_slot_availability, on: :create
  validate :within_business_hours, on: :create

  enum status: { pending: 0, accepted: 1, declined: 2 }, _default: :pending

  def format_time(time)
    time.strftime("%l:%M %P")
  end 

  def format_date(time)
    time.strftime("%a, %B %e")
  end 

  # Attributes for simple_calendar gem
  def start_date
    started_at.to_date
  end
  
  def start_time
    started_at.to_time
  end
  
  def end_time
    ended_at.to_time
  end
    
  private

  # Ensure the booking fits within the business's operating hours
  def within_business_hours
    return unless business && started_at && ended_at

    # Redefine start and end times for comarison * TODO: Make better comment *
    # started_at = started_at.strftime("%H:%M:%S")
    # ended_at = ended_at.strftime("%H:%M:%S")

    # Get the day of the week for the booking
    day_of_week = started_at.in_time_zone(business.time_zone).strftime("%A")
    
    # Find the business hours for that day
    business_hour = business.business_hours.find_by(day_of_the_week: day_of_week)

    opening_time = business_hour.adjusted_opening_time.strftime("%H:%M:%S")
    closing_time = business_hour.adjusted_closing_time.strftime("%H:%M:%S")
  
    # Validate against the business's open and close times
    if business_hour.closed || business_hour.nil?
      errors.add(:base, "The business is closed on #{day_of_week}.")
    elsif started_at.strftime("%H:%M:%S") < opening_time || ended_at.strftime("%H:%M:%S") > closing_time
      errors.add(:base, "The booking time is outside the business hours for #{day_of_week}.")
    end
  end

  def ensure_ended_at_has_value
    if !ended_at
      self.ended_at = started_at + service.duration.minutes
    end
  end

  def convert_times_to_business_timezone
    return unless business

    tz = ActiveSupport::TimeZone[business.time_zone]
    started_at = tz.parse(started_at.to_s) if started_at.present?
    ended_at = tz.parse(ended_at.to_s) if ended_at.present?
  end

    # Validation logic for booking time
    def validate_booking_time(business, proposed_started_at, proposed_ended_at)
      business_bookings = business.accepted_received_bookings
      client_bookings = client.accepted_sent_bookings
  
      bookings = business_bookings + client_bookings
      
      bookings.none? do |booking|
        (proposed_started_at < booking.ended_at) && (proposed_ended_at > booking.started_at)
      end
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
end
  
