# frozen_string_literal: true

module V1
  class CollectionsController < ApplicationController
    before_action :set_collection, only: %i[show update destroy]

    # GET /collections
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :GET, '/v1/collections', 'List collections'
    param :null, Object, allow_nil: true
    def index
      @collections = Collection.all

      render json: @collections
    end

    # GET /collections/1
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :GET, '/v1/collections/:id', 'Show a collection'
    param :null, Object, allow_nil: true
    def show
      render json: @collection
    end

    # POST /collections
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :POST, '/v1/collections', 'Create a collection'
    def create
      @collection = Collection.new(collection_params)

      if @collection.save
        render show: @collection, status: :created, location: v1_collection_url(@collection)
      else
        render json: @collection.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /collections/1
    # DOC GENERATED AUTOMATICALLY: REMOVE THIS LINE TO PREVENT REGENERATING NEXT TIME
    api :PATCH, '/v1/collections/:id', 'Update a collection'
    api :PUT, '/v1/collections/:id', 'Update a collection'
    def update
      if @collection.update(collection_params)
        render show: @collection, status: :ok, location: v1_collection_url(@collection)
      else
        render json: @collection.errors, status: :unprocessable_entity
      end
    end

    # DELETE /collections/1
    def destroy
      @collection.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_collection
        @collection = Collection.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def collection_params
        params.require(:data).permit(:user_id,
                                     :name,
                                     :description,
                                     collectable_collections_attributes: CollectableCollection.attribute_names
                                                                             .map(&:to_sym))
      end
  end
end