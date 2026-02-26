# frozen_string_literal: true

module Api
  module V1
    module Auth
      class MeController < BaseController
        before_action :authenticate_user!

        def show
          render json: current_user, serializer: UserSerializer
        end
      end
    end
  end
end
