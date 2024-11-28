class ApplicationController < ActionController::Base
  skip_forgery_protection
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, :keys => [:username, :first_name, :last_name, :profile_picture, :time_zone])

    devise_parameter_sanitizer.permit(:account_update, :keys => [:first_name, :last_name, :profile_picture, :time_zone])
  end
end
