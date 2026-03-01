# frozen_string_literal: true

class Onboarding::ProfilesController < Onboarding::BaseController
  def edit
    @profile = current_user.onboarding_profile
  end

  def update
    profile = current_user.onboarding_profile
    result = Actions::Update.call(record: profile, attributes: profile_params)

    if result.success?
      complete_onboarding
    else
      @profile = profile
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    current_user.club? ? club_profile_params : user_profile_params
  end

  def complete_onboarding
    current_user.complete_onboarding!
    redirect_to dashboard_path, notice: t("onboarding.welcome")
  end

  def user_profile_params
    params.require(:user_profile).permit(:username, :birth_date, :gender, :bio)
  end

  def club_profile_params
    params.require(:club_profile).permit(:club_name, :cnpj, :address, :phone, 
    :email, :website, :description, :logo)
  end
end
