# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      include Devise::Controllers::Helpers

      before_action :configure_devise_mapping

      private

      def configure_devise_mapping
        request.env["devise.mapping"] = Devise.mappings[:user]
      end
    end
  end
end
