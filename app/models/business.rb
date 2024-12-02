# == Schema Information
#
# Table name: businesses
#
#  id         :bigint           not null, primary key
#  about      :string
#  address    :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint           not null
#
# Indexes
#
#  index_businesses_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#
class Business < ApplicationRecord
  include PgSearch::Model
  multisearchable against: [:name, :address]

  belongs_to :owner, class_name: "User"

  has_one_attached :logo

  has_many :business_hours

  has_many :services

  has_many :received_bookings, class_name: "Booking"

  has_many :accepted_received_bookings, -> { where(status: :accepted) }, class_name: "Booking"

  validates :name, presence: true

  after_create :initialize_business_hours

  def to_s
    "#{name}"
  end

  def time_zone
    owner.time_zone || "UTC"
  end

  private

  def initialize_business_hours
    BusinessHour::DAYS_OF_THE_WEEK.each do |day|
      business_hours.create!(day_of_the_week: day, closed: true)
    end
  end
end
