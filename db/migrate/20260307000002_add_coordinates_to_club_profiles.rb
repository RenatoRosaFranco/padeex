# frozen_string_literal: true

class AddCoordinatesToClubProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :club_profiles, :latitude,  :decimal, precision: 10, scale: 6
    add_column :club_profiles, :longitude, :decimal, precision: 10, scale: 6
    add_index  :club_profiles, [:latitude, :longitude]
  end
end
