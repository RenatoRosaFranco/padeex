# frozen_string_literal: true

class Dashboard::ReservasController < Dashboard::BaseController
  before_action :require_club!

  def index
    @week_start = params[:week_start] ? Date.parse(params[:week_start]) : Date.current.beginning_of_week(:monday)
    @week_end   = @week_start + 6.days
    @week_days  = (@week_start..@week_end).to_a

    court_ids = current_user.courts.pluck(:id)
    @bookings = Booking.where(court_id: court_ids, date: @week_start..@week_end, status: :active)
                       .includes(:user, :court)
                       .order(:date, :starts_at)
  end

  def destroy
    court_ids = current_user.courts.pluck(:id)
    result    = Actions::Find.call(scope: Booking.where(court_id: court_ids), id: params[:id])
    return redirect_to(dashboard_reservas_path, alert: t("errors.booking_not_found")) if result.failure?

    Actions::Update.call(record: result.record, attributes: { status: :cancelled })
    redirect_to dashboard_reservas_path(week_start: params[:week_start]), notice: t("flash.booking.cancelled")
  end
end
