# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  time_zone              :string
#  unconfirmed_email      :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, and :omniauthable
  # TODO: add confirmable back when email is configured
  devise :database_authenticatable, 
         :registerable,
         :recoverable, 
         :rememberable, 
         :validatable,
         :trackable
  
  has_one_attached :profile_picture

  has_many :businesses, foreign_key: :owner_id

  has_many :business_hours, through: :businesses

  has_many :services, through: :businesses

  has_many :sent_bookings, foreign_key: :client_id, class_name: "Booking"
  
  has_many :accepted_sent_bookings, -> { where status: accepted}, foreign_key: :client_id, class_name: "Booking"

  has_many :received_bookings, foreign_key: :owner_id, class_name: "Booking"
  
  has_many :accepted_received_bookings, -> { where status: accepted }, foreign_key: :owner_id, class_name: "Booking"

  def full_name
    "#{first_name} #{last_name}"
  end
end
