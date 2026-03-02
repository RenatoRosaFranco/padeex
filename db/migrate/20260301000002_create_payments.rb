# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.belongs_to :tenant
      t.belongs_to :order, null: false, foreign_key: true
      t.string     :stripe_payment_intent_id
      t.integer    :amount_cents, null: false
      t.string     :currency, null: false, default: "brl"
      t.string     :status, null: false
      t.string     :payment_method_type
      t.jsonb      :stripe_raw
      t.timestamps
    end

    add_index :payments, :stripe_payment_intent_id,
              unique: true,
              where: "stripe_payment_intent_id IS NOT NULL"
  end
end
