# frozen_string_literal: true

class ClubProfileSerializer < ActiveModel::Serializer
  # Attributes
  attributes :id, :name, :address, :phone, :courts, :lat, :lng

  # @return [String] the club name
  def name
    object.club_name
  end

  # @return [Integer] the number of courts
  def courts
    object.user.courts.size
  end

  # @return [Float] the latitude
  def lat
    object.latitude.to_f
  end

  # @return [Float] the longitude
  def lng
    object.longitude.to_f
  end
end
