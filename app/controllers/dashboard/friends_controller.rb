# frozen_string_literal: true

class Dashboard::FriendsController < Dashboard::BaseController
  def index
    @tab = params[:tab].presence_in(%w[seguidores solicitacoes]) || "seguindo"
    @pending_count = current_user.follow_requests_received.count

    case @tab
    when "seguindo"
      @users = current_user.following.includes(:user_profile).order("users.name")
    when "seguidores"
      @users = current_user.followers.includes(:user_profile).order("users.name")
    when "solicitacoes"
      @requests = current_user.follow_requests_received.includes(follower: :user_profile).order(created_at: :desc)
    end

    if params[:q].present?
      q = "%#{params[:q].strip}%"
      @search_results = User.joins("LEFT JOIN user_profiles ON user_profiles.user_id = users.id")
                            .where.not(id: current_user.id)
                            .where("users.name ILIKE :q OR user_profiles.username ILIKE :q", q: q)
                            .where(onboarding_completed: true)
                            .includes(:user_profile)
                            .limit(12)
    end
  end
end
