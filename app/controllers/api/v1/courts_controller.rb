# frozen_string_literal: true

module Api
  module V1
    class CourtsController < BaseController
      before_action :authenticate_user!
      before_action :require_admin!, except: [:index]
      before_action :set_court, only: [:update]

      def index
        render json: Court.available, each_serializer: CourtSerializer
      end

      def create
        result = Actions::Create.call(scope: Court, attributes: court_params)

        if result.success?
          render json: result.record, serializer: CourtSerializer, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      def update
        result = Actions::Update.call(record: @court, attributes: court_params)
        
        if result.success?
          render json: @court, serializer: CourtSerializer
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_court
        result = Actions::Find.call(scope: Court, id: params[:id])
        result.success? ? (@court = result.record) : render(json: { error: I18n.t("errors.court_not_found") }, status: :not_found)
      end

      def court_params
        params.require(:court).permit(:name, :court_type, :status)
      end
    end
  end
end
