# frozen_string_literal: true

module Api
  module V1
    class BookingsController < BaseController
      before_action :authenticate_user!
      before_action :set_court, only: [:create]
      before_action :set_booking, only: [:destroy]

      def create
        date      = Date.parse(params.require(:date))
        starts_at = params.require(:starts_at)

        booking = BookingCreatorService.call(
          court:     @court,
          user:      current_user,
          date:      date,
          starts_at: starts_at
        )

        if booking.persisted?
          render json: booking, serializer: BookingSerializer, status: :created
        else
          render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
        end
      rescue Date::Error, ArgumentError
        render json: { error: I18n.t("errors.invalid_date_or_time") }, status: :unprocessable_entity
      end

      def destroy
        unless @booking.user == current_user || current_user.admin?
          return render json: { error: I18n.t("errors.unauthorized") }, status: :forbidden
        end

        if @booking.cancellable?
          @booking.cancel!
          head :no_content
        else
          render json: { error: I18n.t("errors.cancellation_not_allowed", hours: @booking.cancellation_window) },
                 status: :unprocessable_entity
        end
      end

      private

      def set_court
        result = Actions::Find.call(scope: Court.available, id: params[:court_id])
        result.success? ? (@court = result.record) : render(json: { error: I18n.t("errors.court_not_found") }, status: :not_found)
      end

      def set_booking
        result = Actions::Find.call(scope: Booking, id: params[:id])
        result.success? ? (@booking = result.record) : render(json: { error: I18n.t("errors.booking_not_found") }, status: :not_found)
      end
    end
  end
end
