# frozen_string_literal: true

module Api
  module V1
    class AvailabilityController < BaseController
      before_action :authenticate_user!
      before_action :set_court

      def show
        date = Date.parse(params.require(:date))

        if date < Date.current
          return render json: { error: I18n.t("errors.date_invalid_past") }, status: :unprocessable_entity
        end

        slots = AvailabilityService.call(court: @court, date: date)
        render json: { date: date, court_id: @court.id, slots: slots }
      rescue Date::Error, ArgumentError
        render json: { error: I18n.t("errors.date_invalid_format") }, status: :unprocessable_entity
      end

      private

      def set_court
        result = Actions::Find.call(scope: Court.available, id: params[:court_id])
        result.success? ? (@court = result.record) : render(json: { error: I18n.t("errors.court_not_found") }, status: :not_found)
      end
    end
  end
end
