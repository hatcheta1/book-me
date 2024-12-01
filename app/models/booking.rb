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
  validate :time_slot_availability, on: :create
  validate :within_business_hours, on: :create

  before_validation :ensure_ended_at_has_value

  enum status: { pending: 0, accepted: 1, declined: 2 }, _default: :pending

  def format_time(time)
    time.strftime("%l:%M %P")
  end 

  def format_date(time)
    time.strftime("%B %e, %Y")
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

    # Convert to business's time zone
    tz = ActiveSupport::TimeZone[business.time_zone]
    start_in_tz = started_at.in_time_zone(tz)
    end_in_tz = ended_at.in_time_zone(tz)

    # Get the day of the week for the booking
    day_of_week = start_in_tz.strftime("%A")

    # Find the business hours for that day
    business_hour = business.business_hours.find_by(day_of_the_week: day_of_week)
    
    if business_hour.nil? || business_hour.closed
      Rails.logger.debug "Business is closed on this day."
      errors.add(:base, "The business is closed on #{day_of_week}.")
      return
    end

    # Compare booking times against business hours
    opening_time = business_hour.opening_time.in_time_zone(tz)
    closing_time = business_hour.closing_time.in_time_zone(tz)

    if start_in_tz < opening_time || end_in_tz > closing_time
      Rails.logger.debug "Booking outside hours: #{business_hour.opening_time} - #{business_hour.closing_time}"
      errors.add(:base, "The booking time is outside the business hours for #{day_of_week}.")
    end
  end

  def ensure_ended_at_has_value
    if ended_at.blank?
      self.ended_at = started_at + service.duration.minutes
    end
  end

  # Validation logic for overlapping bookings
  def time_slot_availability
    business = self.business
    return unless business && started_at && ended_at

    tz = ActiveSupport::TimeZone[business.time_zone]
    start_in_tz = started_at.in_time_zone(tz)
    end_in_tz = ended_at.in_time_zone(tz)

    # Check against existing bookings
    unless validate_booking_time(business, start_in_tz, end_in_tz)
      errors.add(:base, "The selected time slot is unavailable.")
    end
  end

  def validate_booking_time(business, proposed_started_at, proposed_ended_at)
    business_bookings = business.accepted_received_bookings
    client_bookings = client.sent_bookings

    bookings = business_bookings + client_bookings

    bookings.none? do |booking|
      (proposed_started_at < booking.ended_at) && (proposed_ended_at > booking.started_at)
    end
  end
end
  
