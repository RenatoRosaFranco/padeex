# frozen_string_literal: true

module Dashboard
  module Payments
    class PixController < Dashboard::BaseController
      def show
        @order = Order.find_by!(id: params[:id], user_id: current_user.id)
      rescue ActiveRecord::RecordNotFound
        redirect_to dashboard_path, alert: t("errors.not_found")
      end
    end
  end
end
