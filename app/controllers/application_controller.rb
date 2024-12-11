class ApplicationController < ActionController::Base
  include Pundit

  skip_forgery_protection
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_time_zone, if: :user_signed_in?

  after_action :verify_authorized, unless: :devise_controller?
  after_action :verify_policy_scoped, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username, :first_name, :last_name, :profile_picture, :time_zone ])

    devise_parameter_sanitizer.permit(:account_update, keys: [ :first_name, :last_name, :profile_picture, :time_zone ])
  end

  private
    def set_time_zone
      Time.zone = current_user.time_zone
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
  
      redirect_back fallback_location: root_url
    end
end
