# frozen_string_literal: true

class Payment < ApplicationRecord
  include BelongsToTenant

  # Associations
  belongs_to :order

  # Enums
  enum :status, {
    pending:   "pending",
    succeeded: "succeeded",
    failed:    "failed"
  }
end
