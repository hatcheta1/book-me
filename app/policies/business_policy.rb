class BusinessPolicy < ApplicationPolicy
  attr_reader :user, :business

  def initialize(user, business)
    @user = user
    @business = business
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    true
  end

  def edit?
    user == business.owner
  end

  def create?
    new?
  end

  def update?
    edit?
  end

  def destroy?
    user == business.owner
  end
end
