class SearchController < ApplicationController
  def index
    @results = PgSearch.multisearch(params[:query])

    respond_to do |format|
      format.js
    end
  end
end
