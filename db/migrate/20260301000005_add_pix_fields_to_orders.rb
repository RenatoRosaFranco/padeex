# frozen_string_literal: true

class AddPixFieldsToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :openpix_correlation_id, :string
    add_column :orders, :pix_brcode,             :text
    add_column :orders, :pix_qrcode_url,         :string
    add_column :orders, :pix_expires_at,          :datetime

    add_index :orders, :openpix_correlation_id,
              unique: true,
              where: "openpix_correlation_id IS NOT NULL"
  end
end
