# frozen_string_literal: true

module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        before_action :configure_devise_mapping

        respond_to :json

        private

        def configure_devise_mapping
          request.env["devise.mapping"] = Devise.mappings[:user]
        end

        def respond_with(resource, _opts = {})
          render json: resource, serializer: UserSerializer
        end

        def respond_to_on_destroy
          head :no_content
        end
      end
    end
  end
end
