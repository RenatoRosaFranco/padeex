# frozen_string_literal: true

module Api
  module V1
    class TimeBlocksController < BaseController
      before_action :authenticate_user!
      before_action :require_admin!
      before_action :set_court
      before_action :set_time_block, only: [:destroy]

      def index
        blocks = @court.time_blocks.for_date(params.require(:date))
        render json: blocks, each_serializer: TimeBlockSerializer
      end

      def create
        result = Actions::Create.call(scope: @court.time_blocks, attributes: time_block_params)
        if result.success?
          render json: result.record, serializer: TimeBlockSerializer, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        Actions::Remove.call(record: @time_block)
        head :no_content
      end

      private

      def set_court
        result = Actions::Find.call(scope: Court, id: params[:court_id])
        result.success? ? (@court = result.record) : render(json: { error: I18n.t("errors.court_not_found") }, status: :not_found)
      end

      def set_time_block
        result = Actions::Find.call(scope: @court.time_blocks, id: params[:id])
        result.success? ? (@time_block = result.record) : render(json: { error: I18n.t("errors.time_block_not_found") }, status: :not_found)
      end

      def time_block_params
        params.require(:time_block).permit(:date, :starts_at, :ends_at, :reason)
      end
    end
  end
end
