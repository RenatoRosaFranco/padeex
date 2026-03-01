# frozen_string_literal: true

module Api
  module V1
    class HealthcheckController < BaseController
      def show
        render json: HealthcheckResult.current, serializer: HealthcheckSerializer
      end
    end
  end
end
