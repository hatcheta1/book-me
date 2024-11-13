# == Schema Information
#
# Table name: services
#
#  id          :bigint           not null, primary key
#  description :string
#  duration    :integer
#  name        :string
#  price       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  business_id :bigint           not null
#
# Indexes
#
#  index_services_on_business_id  (business_id)
#
# Foreign Keys
#
#  fk_rails_...  (business_id => businesses.id)
#
class Service < ApplicationRecord
  belongs_to :business

  def to_time
    hours = duration / 60
    remainder = duration % 60

    if remainder != 0
      "#{hours} h #{remainder} mins"
    else
      "#{hours} h"
    end
  end
end
