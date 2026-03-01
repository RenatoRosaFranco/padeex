# frozen_string_literal: true

class Dashboard::BookingsController < Dashboard::BaseController
  before_action :set_booking, only: [:destroy]

  def index
    @upcoming = current_user.bookings.active
                            .where("date >= ?", Date.current)
                            .order(date: :asc, starts_at: :asc)
    @past     = current_user.bookings
                            .where("date < ?", Date.current)
                            .order(date: :desc, starts_at: :desc)
                            .limit(20)
  end

  def destroy
    if @booking.cancellable?
      @booking.cancel!
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove("booking-#{@booking.id}") }
        format.html { redirect_to dashboard_bookings_path, notice: t("flash.booking.cancelled") }
      end
    else
      redirect_to dashboard_bookings_path,
                  alert: t("errors.cancellation_not_allowed", hours: BookingSchedule::CANCELLATION_WINDOW)
    end
  end

  private

  def set_booking
    result = Actions::Find.call(scope: current_user.bookings, id: params[:id])
    result.success? ? (@booking = result.record) : redirect_to(dashboard_bookings_path, alert: t("errors.booking_not_found"))
  end
end
