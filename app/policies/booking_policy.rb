class BookingPolicy < ApplicationPolicy
  attr_reader :user, :booking

  def initialize(user, booking)
    @user = user
    @booking = booking unless booking.is_a?(Class)
  end

  def index_for_business?
    user.businesses.exists?
  end

  def index_for_client?
    user.sent_bookings.exists?
  end

  def show?
    index_for_business? || index_for_client?
  end

  def new?
    true
  end

  def edit?
    index_for_business?
  end

  def create?
    new?
  end

  def update?
    edit?
  end

  def destroy?
    index_for_business?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.businesses.exists?
        scope.where(business: user.businesses)
      elsif user.bookings.exists?
        scope.where(client: user)
      else
        scope.none
      end
    end
  end
end
