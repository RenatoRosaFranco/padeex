# frozen_string_literal: true

class AddHourlyRateCentsToCourts < ActiveRecord::Migration[8.1]
  def change
    add_column :courts, :hourly_rate_cents, :integer
  end
end
