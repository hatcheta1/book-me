class SearchController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized 
  skip_after_action :verify_policy_scoped 
  
  def index
    @results = PgSearch.multisearch(params[:query])

    respond_to do |format|
      format.js
    end
  end
end
# It seems like this can also be a concern named PG searchable
