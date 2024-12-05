class HomeController < ApplicationController
  def redirect_root
    if current_user&.businesses&.present?
      redirect_to business_path(current_user.businesses.first)
    else
      redirect_to businesses_path
    end
  end
end
