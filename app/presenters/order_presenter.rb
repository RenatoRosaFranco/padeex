# frozen_string_literal: true

# Presents Order for display (description, amounts, etc.).
class OrderPresenter
  # @param order [Order]
  def initialize(order)
    @order = order
  end

  # Human-readable description of what the order is for.
  #
  # @return [String]
  def description
    case @order.orderable
    when TournamentRegistration
      @order.orderable.tournament_category.name
    when Booking
      booking = @order.orderable
      "#{booking.court.name} – #{I18n.l(booking.date, format: :short)} #{booking.starts_at.strftime('%H:%M')}"
    else
      @order.orderable.class.name
    end
  end
end
