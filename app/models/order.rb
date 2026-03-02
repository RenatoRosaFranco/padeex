# frozen_string_literal: true

class Order < ApplicationRecord
  include BelongsToTenant

  # Associations
  belongs_to :user
  belongs_to :orderable, polymorphic: true
  has_one :payment, dependent: :destroy

  # Enums
  enum :status, {
    pending:    "pending",
    processing: "processing",
    paid:       "paid",
    failed:     "failed",
    cancelled:  "cancelled"
  }

  # @return [String] Description of the order
  def description
    case orderable
    when TournamentRegistration
      orderable.tournament_category.name
    when Booking
      "#{orderable.court.name} – #{I18n.l(orderable.date, format: :short)} #{orderable.starts_at.strftime('%H:%M')}"
    else
      orderable.class.name
    end
  end

  # @return [Float] Amount in BRL
  def amount_brl
    amount_cents / 100.0
  end
end
