class BookingPolicy < ApplicationPolicy
  attr_reader :user, :booking

  def initialize(user, booking)
    @user = user
    @booking = booking
  end

  def index_for_business?
    user.businesses.exists?
  end

  def index_for_client?
    true
  end

  def show?
    user == booking.business.owner || user == booking.client
  end

  def new?
    true
  end

  def edit?
    user == booking.business.owner 
  end

  def create?
    user.present?
  end

  def update?
    edit?
  end

  def destroy?
    show?
  end

  def accept?
    user == booking.buisness.owner
  end

  def decline?
    accept?
  end

  class Scope < Scope
    def resolve
      if user.businesses.exists?
        scope.where(business: user.businesses)
      else
        scope.where(client: user)
      end
    end
  end
end
