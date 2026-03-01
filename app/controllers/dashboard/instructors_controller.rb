# frozen_string_literal: true

class Dashboard::InstructorsController < Dashboard::BaseController
  before_action :require_club!
  before_action :set_instructor, only: [:show, :edit, :update, :destroy]

  def index
    @instructors = current_user.instructors.order(:name)
  end

  def show; end

  def new
    @instructor = current_user.instructors.new
  end

  def create
    result = Actions::Create.call(scope: current_user.instructors, attributes: instructor_params)
    if result.success?
      redirect_to dashboard_instructor_path(result.record), notice: t("flash.instructor.created", name: result.record.name)
    else
      @instructor = result.record
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    result = Actions::Update.call(record: @instructor, attributes: instructor_params)
    if result.success?
      redirect_to dashboard_instructor_path(@instructor), notice: t("flash.instructor.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Actions::Remove.call(record: @instructor)
    redirect_to dashboard_instructors_path, notice: t("flash.instructor.removed")
  end

  private

  def set_instructor
    result = Actions::Find.call(scope: current_user.instructors, id: params[:id])
    result.success? ? (@instructor = result.record) : redirect_to(dashboard_instructors_path, alert: t("errors.instructor_not_found"))
  end

  def instructor_params
    params.require(:instructor).permit(
      :name, :email, :phone, :description, :internal_code, :photo
    )
  end
end
