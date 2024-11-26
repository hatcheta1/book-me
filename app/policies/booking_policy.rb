class BookingPolicy < ApplicationPolicy
  attr_reader :user, :booking

  def initialize(user, booking)
    @user = user
    @booking = booking # unless booking.is_a?(Class)
  end

  def index_for_business?
    user.businesses.exists? && user == @booking.business.owner
  end

  def index_for_client?
    true
  end

  def show?
    user == @booking.business.owner || user == @booking.client
  end

  def new?
    true
  end

  def edit?
    user == @booking.business.owner
  end

  def create?
    new?
  end

  def update?
    edit?
  end

  def destroy?
    show?
  end

  def accept?
    edit?
  end

  def decline?
    edit?
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
      elsif user.sent_bookings.exists?
        scope.where(client: user)
      else
        scope.none
      end
    end
  end
end
