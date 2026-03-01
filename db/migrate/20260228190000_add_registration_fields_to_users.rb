# frozen_string_literal: true

class AddRegistrationFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :mobile_number,  :string
    add_column :users, :accepted_terms, :boolean, null: false, default: false
  end
end
