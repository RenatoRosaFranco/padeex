# frozen_string_literal: true

module Dashboard
  module Payments
    class CheckoutsController < Dashboard::BaseController
      def create
        orderable = find_orderable
        return unless orderable

        unless orderable.user_id == current_user.id
          return redirect_to dashboard_path, alert: t("errors.payment_not_authorized")
        end

        order = Order.find_or_initialize_by(orderable: orderable)

        if order.paid?
          return redirect_to success_url_for(orderable), notice: t("flash.payment.success")
        end

        if order.new_record?
          order.assign_attributes(
            user:         current_user,
            amount_cents: amount_cents_for(orderable),
            success_url:  success_url_for(orderable),
            cancel_url:   cancel_url_for(orderable)
          )
          order.save!
        end

        session_url = Payments::CreateCheckoutSessionService.call(order: order)
        redirect_to session_url, allow_other_host: true
      rescue Stripe::StripeError => e
        redirect_to cancel_url_for(orderable), alert: t("errors.payment_failed")
      end

      private

      def find_orderable
        klass = params[:orderable_type].to_s
        unless %w[TournamentRegistration Booking].include?(klass)
          redirect_to dashboard_path, alert: t("errors.not_found")
          return nil
        end
        klass.constantize.find(params[:orderable_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to dashboard_path, alert: t("errors.not_found")
        nil
      end

      def amount_cents_for(orderable)
        case orderable
        when TournamentRegistration
          (orderable.tournament_category.entry_fee * 100).to_i
        when Booking
          orderable.court.hourly_rate_cents.to_i
        end
      end

      def success_url_for(orderable)
        case orderable
        when TournamentRegistration
          dashboard_tournament_category_url(
            orderable.tournament_category.tournament,
            orderable.tournament_category,
            tab: "inscritos"
          )
        when Booking
          dashboard_bookings_url
        end
      end

      def cancel_url_for(orderable)
        case orderable
        when TournamentRegistration
          dashboard_tournament_category_url(
            orderable.tournament_category.tournament,
            orderable.tournament_category,
            tab: "inscritos"
          )
        when Booking
          dashboard_bookings_url
        end
      end
    end
  end
end
