# frozen_string_literal: true

class Dashboard::ReservationsController < Dashboard::BaseController
  before_action :set_court

  def new
    @date  = parse_date(params[:date]) || Date.tomorrow
    @slots = AvailabilityService.call(court: @court, date: @date)
  end

  def create
    @date  = Date.parse(params.require(:date))
    booking = BookingCreatorService.call(
      court:     @court,
      user:      current_user,
      date:      @date,
      starts_at: params.require(:starts_at)
    )

    if booking.persisted?
      redirect_to dashboard_bookings_path,
                  notice: t("flash.booking.confirmed", date: l(@date, format: :long), time: params[:starts_at])
    else
      @slots = AvailabilityService.call(court: @court, date: @date)
      flash.now[:alert] = booking.errors.full_messages.first
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_court
    result = Actions::Find.call(scope: Court.available, id: params[:court_id])
    result.success? ? (@court = result.record) : redirect_to(dashboard_courts_path, alert: t("errors.court_not_found"))
  end

  def parse_date(str)
    Date.parse(str) if str.present?
  rescue Date::Error
    nil
  end
end
