# frozen_string_literal: true

class Dashboard::TournamentGroupMembershipsController < Dashboard::BaseController
  before_action :require_club!
  before_action :set_context
  before_action :set_membership, only: [:destroy]

  def create
    registration = @category.registrations.find(params[:tournament_group_membership][:tournament_registration_id])
    result = Actions::Create.call(scope: @group.memberships, attributes: { tournament_registration: registration })
    if result.success?
      redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "chaves"),
                  notice: t("flash.tournament_group_membership.created", member: registration.display_name, group: @group.name)
    else
      redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "chaves"),
                  alert: result.errors&.first
    end
  end

  def destroy
    Actions::Remove.call(record: @membership)
    redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "chaves"),
                notice: t("flash.tournament_group_membership.removed")
  end

  private

  def set_context
    result_t = Actions::Find.call(scope: current_user.tournaments, id: params[:tournament_id])
    return redirect_to(dashboard_tournaments_path, alert: t("errors.not_found")) if result_t.failure?
    @tournament = result_t.record

    result_c = Actions::Find.call(scope: @tournament.categories, id: params[:category_id])
    return redirect_to(dashboard_tournament_path(@tournament), alert: t("errors.not_found")) if result_c.failure?
    @category = result_c.record

    result_g = Actions::Find.call(scope: @category.groups, id: params[:group_id])
    return redirect_to(dashboard_tournament_category_path(@tournament, @category, tab: "chaves"), alert: t("errors.not_found")) if result_g.failure?
    @group = result_g.record
  end

  def set_membership
    result = Actions::Find.call(scope: @group.memberships, id: params[:id])
    result.success? ? (@membership = result.record) : redirect_to(dashboard_tournament_category_path(@tournament, @category, tab: "chaves"), alert: t("errors.tournament_group_membership_not_found"))
  end
end
