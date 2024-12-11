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
  include BookingValidation

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

  scope :for_this_week, -> {
  where("started_at >= ? AND started_at <= ?", Date.today.beginning_of_week, Date.today.end_of_week)
  }

  private

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
end
