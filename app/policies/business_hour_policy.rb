class BusinessHourPolicy < ApplicationPolicy
  attr_reader :user, :business_hour

  def initialize(user, business_hour)
    @user = user
    @business_hour = business_hour
  end

  def index?
    true
  end

  def new?
    false
  end

  def edit?
    user == business_hour.business.owner
  end

  def create?
    new?
  end

  def update?
    edit?
  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      scope.where(business: user.businesses)
    end
  end
end
