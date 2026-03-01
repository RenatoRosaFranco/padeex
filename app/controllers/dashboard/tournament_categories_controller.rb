# frozen_string_literal: true

class Dashboard::TournamentCategoriesController < Dashboard::BaseController
  before_action :set_tournament
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :require_club!, only: [:new, :create, :edit, :update, :destroy]

  def show
    @tab = params[:tab].presence_in(%w[inscritos chaves jogos]) || "informacoes"
    @registrations = @category.registrations.includes(:user).order(:status, :created_at)
    @groups        = @category.groups.includes(registrations: :user)
    @matches       = @category.matches.includes(:tournament_group, :home_registration, :away_registration)
    @my_registration = @registrations.find_by(user_id: current_user.id)

    if current_user.club? && @tournament.club_id == current_user.id
      @assignable = @category.registrations.confirmed.where.not(
        id: TournamentGroupMembership.select(:tournament_registration_id)
      ).includes(:user)
      @courts = current_user.courts.order(:name)
    end
  end

  def new
    @category = @tournament.categories.new
  end

  def create
    result = Actions::Create.call(scope: @tournament.categories, attributes: category_params)
    if result.success?
      redirect_to dashboard_tournament_category_path(@tournament, result.record),
                  notice: t("flash.tournament_category.created", name: result.record.name)
    else
      @category = result.record
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    result = Actions::Update.call(record: @category, attributes: category_params)
    if result.success?
      redirect_to dashboard_tournament_category_path(@tournament, @category),
                  notice: t("flash.tournament_category.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Actions::Remove.call(record: @category)
    redirect_to dashboard_tournament_path(@tournament), notice: t("flash.tournament_category.removed")
  end

  private

  def set_tournament
    result = Actions::Find.call(scope: Tournament, id: params[:tournament_id])
    result.success? ? (@tournament = result.record) : redirect_to(dashboard_tournaments_path, alert: t("errors.tournament_not_found"))
  end

  def set_category
    result = Actions::Find.call(scope: @tournament.categories, id: params[:id])
    result.success? ? (@category = result.record) : redirect_to(dashboard_tournament_path(@tournament), alert: t("errors.tournament_category_not_found"))
  end

  def category_params
    params.require(:tournament_category).permit(
      :name, :description, :gender, :level,
      :max_pairs, :entry_fee, :registration_deadline, :position
    )
  end
end
