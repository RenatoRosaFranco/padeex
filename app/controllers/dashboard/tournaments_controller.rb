# frozen_string_literal: true

class Dashboard::TournamentsController < Dashboard::BaseController
  before_action :require_club!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_tournament, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.club?
      @tournaments = current_user.tournaments.order(starts_on: :desc)
      @my_club_view = true
    else
      @tournaments = Tournament.where(status: [:open, :in_progress, :finished])
                               .includes(:categories, :club)
                               .order(starts_on: :desc)
    end
  end

  def show
    @categories = @tournament.categories.includes(:registrations)
  end

  def new
    @tournament = current_user.tournaments.new
  end

  def create
    result = Actions::Create.call(scope: current_user.tournaments, attributes: tournament_params)
    if result.success?
      redirect_to dashboard_tournament_path(result.record), notice: t("flash.tournament.created", name: result.record.name)
    else
      @tournament = result.record
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    result = Actions::Update.call(record: @tournament, attributes: tournament_params)
    if result.success?
      redirect_to dashboard_tournament_path(@tournament), notice: t("flash.tournament.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Actions::Remove.call(record: @tournament)
    redirect_to dashboard_tournaments_path, notice: t("flash.tournament.removed")
  end

  private

  def set_tournament
    result = Actions::Find.call(scope: Tournament, id: params[:id])
    result.success? ? (@tournament = result.record) : redirect_to(dashboard_tournaments_path, alert: t("errors.tournament_not_found"))
  end

  def tournament_params
    params.require(:tournament).permit(
      :name, :description, :starts_on, :ends_on,
      :format, :max_teams, :entry_fee, :status,
      :banner, :edital
    )
  end
end
