# frozen_string_literal: true

module V1
  class CollectionsController < ApplicationController
    before_action :require_login, except: %i[show index summary]
    before_action :set_collection, only: %i[show update]
    after_action :verify_authorized

    api :GET, '/v1/users/:user_id/collections', "Show a user's collections"
    param :user_id, String, allow_nil: false
    param :images, :bool, default: true, required: false, allow_nil: false
    param :page, Hash, required: false do
      param :size, String, default: 10
    end

    def index
      @collections = paginate(CollectionPolicy::Scope.new(
        current_user,
        params[:user_id],
        Collection.build_query(params)
      ).resolve)
      authorize @collections
      render :index
    end

    api :GET, '/v1/users/:user_id/collections/summary', "Show a user's collections summary"
    param :user_id, String, allow_nil: false
    def summary
      @collections = paginate(CollectionPolicy::Scope.new(
        current_user,
        params[:user_id],
        Collection.select(:id, :name)
      ).resolve)
      authorize @collections
      render :summary
    end

    api :GET, '/v1/collections/:id', 'Show a collection'
    param :id, String, allow_nil: false
    error :forbidden, 'You are not authorized to perform this action'

    def show
      authorize @collection
      render :show
    end

    api :POST, '/v1/users/:user_id/collections', 'Create a collection'
    param :user_id, String, allow_nil: false
    error :unauthorized, 'Request missing Authorization header'

    def create
      @collection = Collection.new(collection_params)
      authorize @collection

      if @collection.save
        render :show, status: :created, location: v1_collection_url(@collection)
      else
        render json: @collection.errors, status: :unprocessable_entity
      end
    end

    api :PATCH, '/v1/collections/:id', 'Update a collection'
    api :PUT, '/v1/collections/:id', 'Update a collection'
    param :id, String, allow_nil: false
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'

    def update
      authorize @collection

      if @collection.update(collection_params)
        render :show, status: :ok, location: v1_collection_url(@collection)
      else
        render json: @collection.errors, status: :unprocessable_entity
      end
    end

    api :DELETE, 'v1/collections/:id', 'Destroy a collection'
    param :id, String, allow_nil: false
    error :unauthorized, 'Request missing Authorization header'
    error :forbidden, 'You are not authorized to perform this action'

    def destroy
      collection = Collection.find(params[:id])
      authorize collection
      collection.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_collection
        @collection = Collection.build_query(params).find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def collection_params
        collection = @collection || Collection.new
        params.require(:data).permit(policy(collection).permitted_attributes).merge(user_id: current_user.id)
      end
  end
end
