# frozen_string_literal: true

class Dashboard::Admin::TimeBlocksController < Dashboard::Admin::BaseController
  before_action :set_court
  before_action :set_time_block, only: [:destroy]

  def index
    @date        = parse_date(params[:date]) || Date.current
    @time_blocks = @court.time_blocks.for_date(@date).order(:starts_at)
    @time_block  = TimeBlock.new(court: @court, date: @date)
  end

  def create
    result = Actions::Create.call(scope: @court.time_blocks, attributes: time_block_params)
    if result.success?
      redirect_to dashboard_admin_court_time_blocks_path(@court, date: result.record.date),
                  notice: t("flash.time_block.created")
    else
      @time_block  = result.record
      @date        = @time_block.date || Date.current
      @time_blocks = @court.time_blocks.for_date(@date).order(:starts_at)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    date = @time_block.date
    Actions::Remove.call(record: @time_block)
    redirect_to dashboard_admin_court_time_blocks_path(@court, date: date), notice: t("flash.time_block.removed")
  end

  private

  def set_court
    result = Actions::Find.call(scope: Court, id: params[:court_id])
    result.success? ? (@court = result.record) : redirect_to(dashboard_admin_courts_path, alert: t("errors.court_not_found"))
  end

  def set_time_block
    result = Actions::Find.call(scope: @court.time_blocks, id: params[:id])
    result.success? ? (@time_block = result.record) : redirect_to(dashboard_admin_court_time_blocks_path(@court), alert: t("errors.time_block_not_found"))
  end

  def time_block_params
    params.require(:time_block).permit(:date, :starts_at, :ends_at, :reason)
  end

  def parse_date(str)
    Date.parse(str) if str.present?
  rescue Date::Error
    nil
  end
end
