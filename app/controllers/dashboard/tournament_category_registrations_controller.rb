# frozen_string_literal: true

class Dashboard::TournamentCategoryRegistrationsController < Dashboard::BaseController
  before_action :set_tournament
  before_action :set_category
  before_action :set_registration, only: [:update, :destroy]

  def create
    if @category.registrations.exists?(user_id: current_user.id)
      return redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "inscritos"),
                         alert: t("errors.tournament_registration_already_registered")
    end

    result = Actions::Create.call(scope: @category.registrations, attributes: registration_params.merge(user: current_user))
    if result.success?
      @registration = result.record
      if @category.entry_fee&.positive?
        initiate_registration_payment
      else
        redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "inscritos"),
                    notice: t("flash.tournament_registration.created")
      end
    else
      redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "inscritos"),
                  alert: result.errors&.first
    end
  end

  def update
    unless club_owner?
      return redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "inscritos"),
                         alert: t("errors.tournament_registration_club_only")
    end

    result = Actions::Update.call(record: @registration, attributes: { status: params[:tournament_registration][:status] })
    if result.success?
      redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "inscritos"),
                  notice: t("flash.tournament_registration.status_updated")
    else
      redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "inscritos"),
                  alert: t("errors.tournament_registration_status_failed")
    end
  end

  def destroy
    unless @registration.user_id == current_user.id || club_owner?
      return redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "inscritos"),
                         alert: t("errors.unauthorized")
    end

    Actions::Remove.call(record: @registration)
    redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "inscritos"),
                notice: t("flash.tournament_registration.removed")
  end

  private

  def set_tournament
    result = Actions::Find.call(scope: Tournament, id: params[:tournament_id])
    result.success? ? (@tournament = result.record) : redirect_to(dashboard_tournaments_path, alert: t("errors.tournament_not_found"))
  end

  def set_category
    result = Actions::Find.call(scope: @tournament.categories, id: params[:category_id])
    result.success? ? (@category = result.record) : redirect_to(dashboard_tournament_path(@tournament), alert: t("errors.tournament_category_not_found"))
  end

  def set_registration
    result = Actions::Find.call(scope: @category.registrations, id: params[:id])
    result.success? ? (@registration = result.record) : redirect_to(dashboard_tournament_category_path(@tournament, @category, tab: "inscritos"), alert: t("errors.tournament_registration_not_found"))
  end

  def registration_params
    params.require(:tournament_registration).permit(:partner_name, :partner_phone)
  end

  def club_owner?
    current_user.club? && @tournament.club_id == current_user.id
  end

  def initiate_registration_payment
    category_url = dashboard_tournament_category_url(@tournament, @category, tab: "inscritos")

    order = Order.find_or_initialize_by(orderable: @registration)
    if order.new_record?
      order.assign_attributes(
        user:         current_user,
        amount_cents: (@category.entry_fee * 100).to_i,
        success_url:  category_url,
        cancel_url:   category_url
      )
      order.save!
    end

    if params[:payment_method] == "pix"
      Payments::CreatePixChargeService.call(order: order)
      redirect_to dashboard_payments_pix_path(order)
    else
      session_url = Payments::CreateCheckoutSessionService.call(order: order)
      redirect_to session_url, allow_other_host: true
    end
  rescue StandardError => e
    Sentry.capture_exception(e) if defined?(Sentry)
    redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "inscritos"),
                alert: t("errors.payment_failed")
  end
end
