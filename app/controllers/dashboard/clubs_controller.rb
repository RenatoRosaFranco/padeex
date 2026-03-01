# frozen_string_literal: true

class Dashboard::ClubsController < Dashboard::BaseController
  def index
    @clubs = User.where(kind: :club).order(:name)
  end

  def show
    @club        = User.where(kind: :club).find(params[:id])
    @courts      = @club.courts.available.order(:name)
    @instructors = @club.instructors.order(:name)
  end
end
