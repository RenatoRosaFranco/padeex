# frozen_string_literal: true

class SegmentsController < ApplicationController
  layout "landing"

  # Slugs for the segments.
  SEGMENT_SLUGS = %w[athletes clubs companies investors].freeze

  # GET /segments/:slug
  def show
    @segment = params[:slug] || params[:id]
    return render "errors/not_found", status: :not_found unless SEGMENT_SLUGS.include?(@segment)
  end
end
