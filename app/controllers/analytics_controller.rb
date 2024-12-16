class AnalyticsController < ApplicationController
  before_action :set_business
  before_action :authorize_analytics
  skip_after_action :verify_policy_scoped

  def index
  end

  def popular_hours
    popular_times = Booking.popular_times(@business.id)
    
    formatted_times = popular_times.transform_keys { |hour| format_time(hour) }
    
    render json: formatted_times
  end

  def popular_days
    render json: Booking.by_day_of_week(@business.id).transform_keys { |day| Date::DAYNAMES[day] }
  end 

  def popular_services
    render json: Booking.popular_services(@business.id)
  end

  private

  def set_business
   @business = current_user.businesses.first
  end

  def authorize_analytics
    authorize :analytic
  end

  def format_time(hour)
    hour_in_12_hour_format = hour % 12
    hour_in_12_hour_format = 12 if hour_in_12_hour_format == 0 
    
    am_pm = hour < 12 ? 'AM' : 'PM'
    
    "#{hour_in_12_hour_format} #{am_pm}"
  end
end
