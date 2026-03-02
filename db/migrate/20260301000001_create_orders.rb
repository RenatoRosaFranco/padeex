# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.belongs_to :tenant
      t.belongs_to :user, null: false, foreign_key: true
      t.references :orderable, polymorphic: true, null: false
      t.integer    :amount_cents, null: false
      t.string     :currency, null: false, default: "brl"
      t.string     :status, null: false, default: "pending"
      t.string     :stripe_checkout_session_id
      t.string     :success_url
      t.string     :cancel_url
      t.datetime   :paid_at
      t.timestamps
    end

    add_index :orders, :stripe_checkout_session_id, unique: true
  end
end
