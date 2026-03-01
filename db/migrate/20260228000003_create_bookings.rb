# frozen_string_literal: true

class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :tenant, null: true, foreign_key: true
      t.references :court, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.time :starts_at, null: false
      t.time :ends_at, null: false
      t.string :status, null: false, default: "active"

      t.timestamps
    end

    add_index :bookings, [:court_id, :date]
    add_index :bookings, [:user_id, :date]
    # Prevents double-booking: same court + date + slot can only have one active booking.
    add_index :bookings,
              [:tenant_id, :court_id, :date, :starts_at],
              unique: true,
              where: "status = 'active'",
              name: "index_bookings_on_tenant_court_date_starts_active"
  end
end
