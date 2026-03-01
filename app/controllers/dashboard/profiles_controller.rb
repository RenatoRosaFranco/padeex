# frozen_string_literal: true

class Dashboard::ProfilesController < Dashboard::BaseController
  def show
    @target_user     = current_user
    @profile         = current_user.club? ? current_user.club_profile : current_user.user_profile
    @is_owner        = true
    @followers_count = current_user.followers.count
    @following_count = current_user.following.count
    render template: "profiles/show"
  end

  def edit
    @profile = current_user.club? ? (current_user.club_profile || current_user.build_club_profile)
                                  : (current_user.user_profile  || current_user.build_user_profile)
  end

  def update
    current_user.club? ? update_club : update_user
  end

  private

  def update_user
    profile = current_user.user_profile || current_user.build_user_profile
    user_ok = Actions::Update.call(record: current_user, attributes: user_base_params).success?
    prof_ok = Actions::Update.call(record: profile, attributes: user_profile_params).success?

    if user_ok && prof_ok
      redirect_to dashboard_meu_perfil_path, notice: t("flash.profile.updated")
    else
      @profile = profile
      render :edit, status: :unprocessable_entity
    end
  end

  def update_club
    profile = current_user.club_profile || current_user.build_club_profile
    user_ok = Actions::Update.call(record: current_user, attributes: user_base_params).success?
    prof_ok = Actions::Update.call(record: profile, attributes: club_profile_params).success?

    if user_ok && prof_ok
      redirect_to dashboard_meu_perfil_path, notice: t("flash.profile.updated")
    else
      @profile = profile
      render :edit, status: :unprocessable_entity
    end
  end

  def user_base_params
    params.fetch(:user, {}).permit(:name, :mobile_number)
  end

  def user_profile_params
    params.fetch(:user_profile, {}).permit(:username, :birth_date, :gender, :bio, :avatar)
  end

  def club_profile_params
    params.fetch(:club_profile, {}).permit(:club_name, :cnpj, :address, :phone, :email, :website, :description, :logo)
  end
end
