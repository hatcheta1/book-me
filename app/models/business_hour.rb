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
end
