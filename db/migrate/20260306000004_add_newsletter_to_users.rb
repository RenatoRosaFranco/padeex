# frozen_string_literal: true

class AddNewsletterToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :newsletter_subscribed, :boolean, null: false, default: true
    add_column :users, :unsubscribe_token,     :string

    add_index :users, :unsubscribe_token, unique: true
  end
end
