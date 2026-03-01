# frozen_string_literal: true

class Dashboard::Admin::CourtsController < Dashboard::Admin::BaseController
  before_action :set_court, only: [:edit, :update]

  def index
    @courts = Court.all.order(:name)
  end

  def new
    @court = Court.new
  end

  def create
    result = Actions::Create.call(scope: Court, attributes: court_params)
    if result.success?
      redirect_to dashboard_admin_courts_path, notice: t("flash.court.created", name: result.record.name)
    else
      @court = result.record
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    result = Actions::Update.call(record: @court, attributes: court_params)
    if result.success?
      redirect_to dashboard_admin_courts_path, notice: t("flash.court.updated", name: @court.name)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_court
    result = Actions::Find.call(scope: Court, id: params[:id])
    result.success? ? (@court = result.record) : redirect_to(dashboard_admin_courts_path, alert: t("errors.court_not_found"))
  end

  def court_params
    params.require(:court).permit(:name, :court_type, :status)
  end
end
