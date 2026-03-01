# frozen_string_literal: true

class Dashboard::FollowsController < Dashboard::BaseController
  before_action :set_follow, only: [:destroy, :update]

  def create
    followed = User.find(params[:followed_id])

    return redirect_back(fallback_location: dashboard_friends_path) if followed == current_user

    follow = current_user.active_follows.find_or_initialize_by(followed: followed)

    if follow.new_record?
      follow.status = "pending"
      follow.save
    end

    redirect_back fallback_location: dashboard_friends_path
  end

  def update
    # Accept or reject a follow request received by current_user
    follow = current_user.passive_follows.find(params[:id])

    if params[:accept]
      follow.update(status: "accepted")
    else
      follow.destroy
    end

    redirect_to dashboard_friends_path(tab: "solicitacoes")
  end

  def destroy
    # Unfollow (called by follower) or remove follower (called by followed)
    if @follow.follower_id == current_user.id || @follow.followed_id == current_user.id
      @follow.destroy
    end

    redirect_back fallback_location: dashboard_friends_path
  end

  private

  def set_follow
    @follow = Follow.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: dashboard_friends_path
  end
end
