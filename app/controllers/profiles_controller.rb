# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_onboarding_completed!

  layout "dashboard"

  def show
    @target_user      = User.find(params[:id])
    @profile          = @target_user.club? ? @target_user.club_profile : @target_user.user_profile
    @is_owner         = current_user == @target_user
    @follow_record    = current_user.follow_record_with(@target_user) unless @is_owner
    @followers_count  = @target_user.followers.count
    @following_count  = @target_user.following.count
  end

  private

  def require_onboarding_completed!
    redirect_to edit_onboarding_personal_info_path unless current_user.onboarding_completed?
  end
end
