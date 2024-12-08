class HomeController < ApplicationController
  skip_after_action :verify_authorized 
  skip_after_action :verify_policy_scoped 

  def redirect_root
    if current_user&.businesses&.present?
      redirect_to business_path(current_user.businesses.first)
    else
      redirect_to businesses_path
    end
  end
end
