# == Schema Information
#
# Table name: business_hours
#
#  id              :bigint           not null, primary key
#  closed          :boolean
#  closing_time    :time
#  day_of_the_week :string
#  opening_time    :time
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  business_id     :bigint           not null
#
# Indexes
#
#  index_business_hours_on_business_id  (business_id)
#
# Foreign Keys
#
#  fk_rails_...  (business_id => businesses.id)
#
class BusinessHour < ApplicationRecord
  belongs_to :business

  has_one :owner, through: :business

  DAYS_OF_THE_WEEK = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]

  validates :day_of_the_week, :opening_time, :closing_time, presence: true, if: -> { !closed }
  validates :day_of_the_week, inclusion: { in: DAYS_OF_THE_WEEK }
  validates :day_of_the_week, uniqueness: { scope: :business_id, message: "should only have one entry per business day" }

  validate :valid_time_range, if: -> { !closed }

  def format_time(time)
    time.in_time_zone(business.owner.time_zone).strftime("%l:%M %P %Z")
  end

  def adjusted_opening_time
    business_time_to_timezone(opening_time)
  end
  
  def adjusted_closing_time
    business_time_to_timezone(closing_time)
  end

  private

  def valid_time_range
    if opening_time >= closing_time
      errors.add(:base, "Opening time must be before closing time.")
    end
  end

  def business_time_to_timezone(time)
    return nil if closed || time.nil?
  
    Time.use_zone(business.owner.time_zone) do
      # Convert time to the business owner's time zone and return as DateTime
      Time.zone.local(time.year, time.month, time.day, time.hour, time.min).to_datetime
    end
  end
end
