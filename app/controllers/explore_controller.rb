# frozen_string_literal: true

class ExploreController < ApplicationController
  layout "landing"

  def index
    clubs = ClubProfile.mappable.includes(user: :courts)

    @clubs_json = ActiveModel::SerializableResource.new(clubs, each_serializer: ClubProfileSerializer).to_json
    @clubs      = JSON.parse(@clubs_json)
  end
end
