# frozen_string_literal: true

class AddKindToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :kind, :string, null: false, default: "user"
    add_index  :users, :kind
  end
end
