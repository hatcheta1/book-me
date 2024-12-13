class ServicePolicy < ApplicationPolicy
  attr_reader :user, :service

  def initialize(user, service)
    @user = user
    @service = service
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    user.businesses.exists?
  end

  def edit?
    user == service.business.owner
  end

  def create?
    new?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  class Scope < Scope
    def resolve
      scope.joins(:business).where(businesses: { owner_id: user.id })
    end
  end
end
