# frozen_string_literal: true

class Dashboard::TournamentCategoryMatchesController < Dashboard::BaseController
  before_action :require_club!
  before_action :set_tournament
  before_action :set_category
  before_action :set_match, only: [:edit, :update, :destroy]

  def index
    redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "jogos")
  end

  def show
    redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "jogos")
  end

  def new
    @match = @category.matches.new
  end

  def create
    result = Actions::Create.call(scope: @category.matches, attributes: match_params)
    if result.success?
      redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "jogos"),
                  notice: t("flash.tournament_match.created")
    else
      @match         = result.record
      @registrations = @category.registrations.confirmed.includes(:user)
      @groups        = @category.groups
      @courts        = current_user.courts.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @registrations = @category.registrations.confirmed.includes(:user)
    @groups        = @category.groups
    @courts        = current_user.courts.order(:name)
  end

  def update
    result = Actions::Update.call(record: @match, attributes: match_params)
    if result.success?
      redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "jogos"),
                  notice: t("flash.tournament_match.updated")
    else
      @registrations = @category.registrations.confirmed.includes(:user)
      @groups        = @category.groups
      @courts        = current_user.courts.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Actions::Remove.call(record: @match)
    redirect_to dashboard_tournament_category_path(@tournament, @category, tab: "jogos"),
                notice: t("flash.tournament_match.removed")
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

  def set_match
    result = Actions::Find.call(scope: @category.matches, id: params[:id])
    result.success? ? (@match = result.record) : redirect_to(dashboard_tournament_category_path(@tournament, @category, tab: "jogos"), alert: t("errors.tournament_match_not_found"))
  end

  def match_params
    params.require(:tournament_match).permit(
      :tournament_group_id, :home_registration_id, :away_registration_id,
      :court_id, :scheduled_at, :home_score, :away_score, :status, :position
    )
  end
end
