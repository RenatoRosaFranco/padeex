# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      include Devise::Controllers::Helpers
      include SetTenant

      before_action :configure_devise_mapping

      private

      def configure_devise_mapping
        request.env["devise.mapping"] = Devise.mappings[:user]
      end

      def require_admin!
        render json: { error: I18n.t("errors.admin_required") }, status: :forbidden unless current_user&.admin?
      end
    end
  end
end
