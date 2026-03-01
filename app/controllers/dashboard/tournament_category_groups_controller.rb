# frozen_string_literal: true

class Dashboard::TournamentCategoryGroupsController < Dashboard::BaseController
  before_action :require_club!
  before_action :set_tournament
  before_action :set_category
  before_action :set_group, only: [:update, :destroy]

  def create
    result = Actions::Create.call(scope: @category.groups, attributes: group_params)
    if result.success?
      redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "chaves"),
                  notice: t("flash.tournament_group.created", name: result.record.name)
    else
      redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "chaves"),
                  alert: result.errors&.first
    end
  end

  def update
    result = Actions::Update.call(record: @group, attributes: group_params)
    if result.success?
      redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "chaves"),
                  notice: t("flash.tournament_group.updated")
    else
      redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "chaves"),
                  alert: result.errors&.first
    end
  end

  def destroy
    Actions::Remove.call(record: @group)
    redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "chaves"),
                notice: t("flash.tournament_group.removed")
  end

  private

  def set_tournament
    result = Actions::Find.call(scope: current_user.tournaments, id: params[:tournament_id])
    result.success? ? (@tournament = result.record) : redirect_to(dashboard_tournaments_path, alert: t("errors.tournament_not_found"))
  end

  def set_category
    result = Actions::Find.call(scope: @tournament.categories, id: params[:category_id])
    result.success? ? (@category = result.record) : redirect_to(dashboard_tournament_path(@tournament), alert: t("errors.tournament_category_not_found"))
  end

  def set_group
    result = Actions::Find.call(scope: @category.groups, id: params[:id])
    result.success? ? (@group = result.record) : redirect_to(dashboard_tournament_category_path(@tournament, @category, tab: "chaves"), alert: t("errors.tournament_group_not_found"))
  end

  def group_params
    params.require(:tournament_group).permit(:name, :position)
  end
end
