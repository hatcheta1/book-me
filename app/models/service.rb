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
end
