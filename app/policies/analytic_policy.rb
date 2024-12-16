class AnalyticPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user, _analytic)
    @user = user
  end

  def index?
    user.businesses.present?
  end

  def popular_hours?
    index?
  end

  def popular_days?
    index?
  end

  def popular_services?
    index?
  end
end
