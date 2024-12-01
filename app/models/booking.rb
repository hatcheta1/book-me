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
  before_validation :convert_times_to_business_timezone

  before_save :convert_times_to_utc

  enum status: { pending: 0, accepted: 1, declined: 2 }, _default: :pending

  def format_time(time)
    time.in_time_zone(current_user.time_zone).strftime("%l:%M %P %Z")
  end 

  def format_date(time)
    time.in_time_zone(current_user.time_zone).strftime("%B %e, %Y")
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

  def convert_times_to_business_timezone
    return unless business

    tz = ActiveSupport::TimeZone[business.time_zone]
    self.started_at = tz.parse(started_at.to_s) if started_at.present?
    self.ended_at = tz.parse(ended_at.to_s) if ended_at.present?
  end

  # Ensure the booking fits within the business's operating hours
  def within_business_hours
    return unless business && started_at

    # Get the day of the week for the booking
    day_of_week = started_at.in_time_zone(business.time_zone).strftime("%A")
    
    # Find the business hours for that day
    business_hour = business.business_hours.find_by(day_of_the_week: day_of_week)

    if business_hour.closed || business_hour.nil?
      errors.add(:base, "The business is closed on #{day_of_week}.")
      return
    end

    # Adjust the hours to the business's time zone
    opening_time = business_hour.adjusted_opening_time
    closing_time = business_hour.adjusted_closing_time

     # Convert the booking times to the business owner's time zone
     started_at_business_tz = started_at.in_time_zone(business.time_zone)
     ended_at_business_tz = ended_at.in_time_zone(business.time_zone)

    # Ensure the booking starts and ends within the business's hours
    if started_at_business_tz < opening_time ||
      ended_at_business_tz > closing_time
      errors.add(:base, "The booking time is outside the business hours for #{day_of_week}.")
    end
  end

  def ensure_ended_at_has_value
    if ended_at.blank?
      self.ended_at = started_at + service.duration.minutes
    end
  end

  # Convert the times to UTC before saving to the database
  def convert_times_to_utc
    return unless business

    tz = ActiveSupport::TimeZone[business.time_zone]
    
    # Convert started_at and ended_at to UTC before saving
    self.started_at = started_at.in_time_zone(tz).utc if started_at.present?
    self.ended_at = ended_at.in_time_zone(tz).utc if ended_at.present?
  end


  def time_slot_availability
    business_bookings = business.accepted_received_bookings
    client_bookings = client.accepted_sent_bookings

    bookings = business_bookings + client_bookings
    
    bookings.none? do |booking|
      (started_at < booking.ended_at) && (ended_at > booking.started_at)
    end
  end
end
  
