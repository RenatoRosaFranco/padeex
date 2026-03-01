# frozen_string_literal: true

class Dashboard::CourtBookingsController < Dashboard::BaseController
  before_action :require_club!
  before_action :set_court

  def index
    @upcoming = @court.bookings.where(status: :active)
                               .where("date >= ?", Date.current)
                               .includes(:user)
                               .order(:date, :starts_at)

    @past = @court.bookings.where(status: :active)
                           .where("date < ?", Date.current)
                           .includes(:user)
                           .order(date: :desc, starts_at: :desc)
                           .limit(30)
  end

  def destroy
    result = Actions::Find.call(scope: @court.bookings, id: params[:id])
    return redirect_to(dashboard_court_bookings_path(@court), alert: t("errors.booking_not_found")) if result.failure?

    @booking = result.record
    Actions::Update.call(record: @booking, attributes: { status: :cancelled })
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("booking_#{@booking.id}") }
      format.html { redirect_to dashboard_court_bookings_path(@court), notice: t("flash.booking.cancelled") }
    end
  end

  private

  def set_court
    result = Actions::Find.call(scope: current_user.courts, id: params[:court_id])
    result.success? ? (@court = result.record) : redirect_to(dashboard_courts_path, alert: t("errors.court_not_found"))
  end
end
