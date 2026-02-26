# frozen_string_literal: true

module Api
  module V1
    class HealthcheckController < BaseController
      def show
        render json: {
          status: "ok",
          timestamp: Time.current.iso8601,
          version: "1.0"
        }
      end
    end
  end
end
