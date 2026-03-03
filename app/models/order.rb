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
    OrderPresenter.new(self).description
  end

  # @return [Float] Amount in BRL
  def amount_brl
    amount_cents / 100.0
  end
end
