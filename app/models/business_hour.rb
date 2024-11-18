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

  validates :day_of_the_week, inclusion: { in: DAYS_OF_THE_WEEK }
  validates :day_of_the_week, uniqueness: { scope: :business_id, message: "should only have one entry per business day" }

  validates :opening_time, :closing_time, presence: true, if: -> { !closed }
end
