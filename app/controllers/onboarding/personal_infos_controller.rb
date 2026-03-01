# frozen_string_literal: true

class Onboarding::PersonalInfosController < Onboarding::BaseController
  def edit; end

  def update
    result = Actions::Update.call(record: current_user, attributes: personal_info_params)

    if result.success?
      redirect_to edit_onboarding_account_type_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def personal_info_params
    params.require(:user).permit(:name, :mobile_number, :cpf)
  end
end
