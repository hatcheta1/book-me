class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def redirect_root
    if current_user&.businesses&.present?
      redirect_to business_path(current_user.businesses.first)
    else
      redirect_to home_index_path
    end
  end

  def index
  end
end
