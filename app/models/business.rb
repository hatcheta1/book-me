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
  belongs_to :owner, class_name: "User"

  has_many :business_hours

  has_many :services

  has_many :received_bookings, class_name: "Booking"
  
  has_many :accepted_received_bookings, -> { accepted }, class_name: "Booking"

  validates :name, presence: true
end
