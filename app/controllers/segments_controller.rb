# frozen_string_literal: true

class SegmentsController < ApplicationController
  layout "landing"

  # GET /segments/:slug
  def show
    @segment = params[:slug] || params[:id]
    slugs = AppConfigService.fetch(:segment_slugs, default: [])
    return render "errors/not_found", status: :not_found unless slugs.include?(@segment)
  end
end
