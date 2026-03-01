# frozen_string_literal: true

class Onboarding::AccountTypesController < Onboarding::BaseController
  def edit; end

  def update
    result = Actions::Update.call(record: current_user, attributes: account_type_params)

    if result.success?
      redirect_to edit_onboarding_profile_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def account_type_params
    params.require(:user).permit(:kind)
  end
end
