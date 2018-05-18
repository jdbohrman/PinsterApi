# frozen_string_literal: true

module V1
  class SearchController < ApplicationController
    after_action :verify_authorized, except: %i[search]

    api :GET, '/v1/search', "Show an imageable's images"
    param :query, String, allow_nil: false
    def search
      @search = paginate PgSearch.multisearch(params[:query])
    end
  end
end
